import sys
import time

from app.services.aws_client import BASE_URL, get_all_pricing_urls
from app.services.loader import load_known_versions, load_pricing_data
from app.services.schema_builder import generate_missing_schemas

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--load", action="store_true", help="Load pricing data into PostgreSQL")
    parser.add_argument("--name", default=None, help="Filter by service/plan name (e.g. AWSDatabaseSavingsPlans)")
    args = parser.parse_args()

    if args.load:
        result = load_pricing_data(name_filter=args.name)
        print(
            f"\n# Loaded {result['loaded']} regions across {result['services']} services in {result['elapsed_seconds']:.2f}s",
            file=sys.stderr,
        )
    else:
        start = time.time()
        known_versions = load_known_versions()
        all_urls = get_all_pricing_urls(known_versions)
        elapsed = time.time() - start

        schema_start = time.time()
        generate_missing_schemas(all_urls)
        schema_elapsed = time.time() - schema_start

        print("type,name,region,csv_url,publication_date")
        for row in all_urls:
            print(f"{row['type']},{row['name']},{row['region']},{BASE_URL}{row['csv_url']},{row['publication_date']}")

        service_count = sum(1 for r in all_urls if r["type"] == "service")
        sp_count = sum(1 for r in all_urls if r["type"] == "savings_plan")
        print(
            f"\n# Total: {len(all_urls)} rows ({service_count} service, {sp_count} savings_plan)"
            f" in {elapsed:.2f}s (index) {schema_elapsed:.2f}s (schema)",
            file=sys.stderr,
        )
