import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed

import requests

BASE_URL = "https://pricing.us-east-1.amazonaws.com"
SERVICE_INDEX_PATH = "/offers/v1.0/aws/index.json"

SAVINGS_PLAN_REGION_INDEX_PATHS = [
    "/savingsPlan/v1.0/aws/AWSDatabaseSavingsPlans/current/region_index.json",
    "/savingsPlan/v1.0/aws/AWSMachineLearningSavingsPlans/current/region_index.json",
    "/savingsPlan/v1.0/aws/AWSComputeSavingsPlan/current/region_index.json",
]


def fetch_json(path: str) -> dict:
    resp = requests.get(f"{BASE_URL}{path}")
    resp.raise_for_status()
    return resp.json()


def get_service_region_index_urls() -> list[dict]:
    index = fetch_json(SERVICE_INDEX_PATH)
    return [
        {"service": name, "region_index_path": offer["currentRegionIndexUrl"]}
        for name, offer in index["offers"].items()
    ]


def fetch_service_pricing_urls(service: str, region_index_path: str) -> list[dict]:
    try:
        region_index = fetch_json(region_index_path)
    except requests.exceptions.RequestException as e:
        print(f"[WARN] {service}: {e}", file=sys.stderr)
        return []

    publication_date = region_index.get("publicationDate", "")
    results = []
    for region_code, region_data in region_index["regions"].items():
        json_url = region_data["currentVersionUrl"]
        csv_url = json_url.replace(".json", ".csv")
        results.append({
            "type": "service",
            "name": service,
            "region": region_code,
            "region_index_path": region_index_path,
            "csv_url": csv_url,
            "publication_date": publication_date,
        })
    return results


def fetch_savings_plan_pricing_urls(region_index_path: str) -> list[dict]:
    plan_name = region_index_path.split("/")[4]
    try:
        region_index = fetch_json(region_index_path)
    except requests.exceptions.RequestException as e:
        print(f"[WARN] {plan_name}: {e}", file=sys.stderr)
        return []

    publication_date = region_index.get("publicationDate", "")
    results = []
    for region_data in region_index["regions"]:
        json_url = region_data["versionUrl"]
        csv_url = json_url.replace(".json", ".csv")
        results.append({
            "type": "savings_plan",
            "name": plan_name,
            "region": region_data["regionCode"],
            "region_index_path": region_index_path,
            "csv_url": csv_url,
            "publication_date": publication_date,
        })
    return results


def get_all_pricing_urls() -> list[dict]:
    services = get_service_region_index_urls()

    results = []
    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = {
            executor.submit(fetch_service_pricing_urls, s["service"], s["region_index_path"]): s["service"]
            for s in services
        }
        for future in as_completed(futures):
            results.extend(future.result())

    for path in SAVINGS_PLAN_REGION_INDEX_PATHS:
        results.extend(fetch_savings_plan_pricing_urls(path))

    return results


if __name__ == "__main__":
    start = time.time()
    all_urls = get_all_pricing_urls()
    elapsed = time.time() - start

    print("type,name,region,csv_url,publication_date")
    for row in all_urls:
        print(f"{row['type']},{row['name']},{row['region']},{BASE_URL}{row['csv_url']},{row['publication_date']}")

    service_count = sum(1 for r in all_urls if r["type"] == "service")
    sp_count = sum(1 for r in all_urls if r["type"] == "savings_plan")
    print(f"\n# Total: {len(all_urls)} rows ({service_count} service, {sp_count} savings_plan) in {elapsed:.2f}s", file=sys.stderr)
