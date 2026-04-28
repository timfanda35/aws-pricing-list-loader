import re
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed

import requests

BASE_URL = "https://pricing.us-east-1.amazonaws.com"
SERVICE_INDEX_PATH = "/offers/v1.0/aws/index.json"
SAVINGS_PLAN_REGION_INDEX_PATHS = [
    "/savingsPlan/v1.0/aws/AWSDatabaseSavingsPlans/current/region_index.json",
    "/savingsPlan/v1.0/aws/AWSMachineLearningSavingsPlans/current/region_index.json",
    "/savingsPlan/v1.0/aws/AWSComputeSavingsPlan/current/region_index.json",
]


def to_snake_case(name: str) -> str:
    name = re.sub(r'[^a-zA-Z0-9]', ' ', name)
    name = re.sub(r'(?<!^)([A-Z][a-z]|(?<=[a-z])[A-Z])', r'_\1', name)
    name = name.lower()
    name = re.sub(r'\s+', '_', name)
    name = re.sub(r'_+', '_', name)
    return name.strip('_')


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


def fetch_service_pricing_urls(
    service: str,
    region_index_path: str,
    known_versions: frozenset[tuple[str, str]] = frozenset(),
) -> list[dict]:
    try:
        region_index = fetch_json(region_index_path)
    except requests.exceptions.RequestException as e:
        print(f"[WARN] {service}: {e}", file=sys.stderr)
        return []

    publication_date = region_index.get("publicationDate", "")
    snake_name = to_snake_case(service)
    results = []
    for region_code, region_data in region_index["regions"].items():
        json_url = region_data["currentVersionUrl"]
        csv_url = json_url.replace(".json", ".csv")
        version = csv_url.split("/")[5]
        if (snake_name, version) in known_versions:
            print(
                f"[SKIP] {service}/{region_code} version {version} already in aws_pricing_list_versions",
                file=sys.stderr,
            )
            continue
        results.append({
            "type": "service",
            "name": service,
            "region": region_code,
            "region_index_path": region_index_path,
            "csv_url": csv_url,
            "publication_date": publication_date,
        })
    return results


def fetch_savings_plan_pricing_urls(
    region_index_path: str,
    known_versions: frozenset[tuple[str, str]] = frozenset(),
) -> list[dict]:
    plan_name = region_index_path.split("/")[4]
    try:
        region_index = fetch_json(region_index_path)
    except requests.exceptions.RequestException as e:
        print(f"[WARN] {plan_name}: {e}", file=sys.stderr)
        return []

    publication_date = region_index.get("publicationDate", "")
    snake_name = to_snake_case(plan_name)
    results = []
    for region_data in region_index["regions"]:
        json_url = region_data["versionUrl"]
        csv_url = json_url.replace(".json", ".csv")
        version = csv_url.split("/")[5]
        if (snake_name, version) in known_versions:
            print(
                f"[SKIP] {plan_name}/{region_data['regionCode']} version {version} already in aws_pricing_list_versions",
                file=sys.stderr,
            )
            continue
        results.append({
            "type": "savings_plan",
            "name": plan_name,
            "region": region_data["regionCode"],
            "region_index_path": region_index_path,
            "csv_url": csv_url,
            "publication_date": publication_date,
        })
    return results


def get_all_pricing_urls(known_versions: frozenset[tuple[str, str]] = frozenset()) -> list[dict]:
    services = get_service_region_index_urls()

    results = []
    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = {
            executor.submit(fetch_service_pricing_urls, s["service"], s["region_index_path"], known_versions): s["service"]
            for s in services
        }
        for future in as_completed(futures):
            results.extend(future.result())

    for path in SAVINGS_PLAN_REGION_INDEX_PATHS:
        results.extend(fetch_savings_plan_pricing_urls(path, known_versions))

    return results
