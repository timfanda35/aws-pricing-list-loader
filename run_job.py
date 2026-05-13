import sys
import argparse
import logging

from app.migrations import run_migrations
from app.services.aws_client import get_all_pricing_urls
from app.services.loader import load_known_versions, load_pricing_data

logging.basicConfig(level=logging.INFO, stream=sys.stderr)


def run_job(name: str | None = None, force: bool = False) -> None:
    print("[Step 1/3] Running DB migrations...", file=sys.stderr)
    try:
        run_migrations()
    except Exception as e:
        print(f"[FATAL] Migration failed: {e}", file=sys.stderr)
        sys.exit(1)
    print("[Step 1/3] Migrations complete.", file=sys.stderr)

    print("[Step 2/3] Checking pricing list versions...", file=sys.stderr)
    try:
        known_versions = None if force else load_known_versions(name)
        all_urls = get_all_pricing_urls(known_versions)
        new_count = len(all_urls)
    except Exception as e:
        print(f"[FATAL] Version check failed: {e}", file=sys.stderr)
        sys.exit(1)
    print(
        f"[Step 2/3] {new_count} region/service entries with new data"
        + (" (force: skipping version check)" if force else "") + ".",
        file=sys.stderr,
    )

    print("[Step 3/3] Loading pricing data...", file=sys.stderr)
    try:
        result = load_pricing_data(name_filter=name, force=force)
    except Exception as e:
        print(f"[FATAL] Load failed: {e}", file=sys.stderr)
        sys.exit(1)
    print(
        f"[Step 3/3] Loaded {result['loaded']} regions across {result['services']} services"
        f" in {result['elapsed_seconds']:.2f}s.",
        file=sys.stderr,
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="AWS Pricing List Loader — Cloud Run Job")
    parser.add_argument("--force", action="store_true", help="Force reload all services, skipping version check")
    parser.add_argument("--name", default=None, help="Filter by service/plan name (e.g. AWSDatabaseSavingsPlans)")
    args = parser.parse_args()

    run_job(name=args.name, force=args.force)
