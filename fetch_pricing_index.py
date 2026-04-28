import hashlib
import os
import re
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

import psycopg2
import requests
from dotenv import load_dotenv

load_dotenv()

BASE_URL = "https://pricing.us-east-1.amazonaws.com"
SERVICE_INDEX_PATH = "/offers/v1.0/aws/index.json"

SAVINGS_PLAN_REGION_INDEX_PATHS = [
    "/savingsPlan/v1.0/aws/AWSDatabaseSavingsPlans/current/region_index.json",
    "/savingsPlan/v1.0/aws/AWSMachineLearningSavingsPlans/current/region_index.json",
    "/savingsPlan/v1.0/aws/AWSComputeSavingsPlan/current/region_index.json",
]

SCHEMA_DIR = Path(__file__).parent / "schema"

_COLUMN_TYPE_MAPPINGS = {
    'effective_date': 'DATE',
    'lease_contract_length': 'INTEGER',
    'discounted_rate': 'DECIMAL(20,10)',
    'price_per_unit': 'DECIMAL(20,10)',
}
_INDEX_COLUMNS = {'sku', 'region_code', 'discounted_region_code'}


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


def fetch_service_pricing_urls(service: str, region_index_path: str, known_versions: frozenset[tuple[str, str]] = frozenset()) -> list[dict]:
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
            print(f"[SKIP] {service}/{region_code} version {version} already in aws_pricing_list_versions", file=sys.stderr)
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


def fetch_savings_plan_pricing_urls(region_index_path: str, known_versions: frozenset[tuple[str, str]] = frozenset()) -> list[dict]:
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
            print(f"[SKIP] {plan_name}/{region_data['regionCode']} version {version} already in aws_pricing_list_versions", file=sys.stderr)
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


def get_all_pricing_urls() -> list[dict]:
    known_versions = load_known_versions()

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


def to_snake_case(name: str) -> str:
    name = re.sub(r'[^a-zA-Z0-9]', ' ', name)
    name = re.sub(r'(?<!^)([A-Z][a-z]|(?<=[a-z])[A-Z])', r'_\1', name)
    name = name.lower()
    name = re.sub(r'\s+', '_', name)
    name = re.sub(r'_+', '_', name)
    return name.strip('_')


def load_known_versions() -> frozenset[tuple[str, str]]:
    try:
        conn = psycopg2.connect(
            host=os.environ["POSTGRES_HOST"],
            port=int(os.environ.get("POSTGRES_PORT", 5432)),
            dbname=os.environ["POSTGRES_DB"],
            user=os.environ["POSTGRES_USER"],
            password=os.environ["POSTGRES_PASSWORD"],
        )
        try:
            with conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT name, version FROM aws_pricing_list_versions")
                    return frozenset(cur.fetchall())
        finally:
            conn.close()
    except (KeyError, psycopg2.OperationalError) as e:
        print(f"[WARN] DB unavailable, skipping version filter: {e}", file=sys.stderr)
        return frozenset()


def get_csv_column_names(csv_url: str) -> list[str]:
    with requests.get(csv_url, stream=True) as resp:
        resp.raise_for_status()
        for i, line in enumerate(resp.iter_lines()):
            if i == 5:
                raw = line.decode('utf-8')
                return [to_snake_case(col.strip('"')) for col in raw.split(',')]
    return []


def _column_definition(col: str) -> str:
    col_type = _COLUMN_TYPE_MAPPINGS.get(col, 'TEXT')
    definition = f'"{col}" {col_type}'
    if col == 'rate_code':
        definition = f"{definition} PRIMARY KEY"
    return f"    {definition}"


def _index_name(table: str, version: str, col: str) -> str:
    full = f"{table.removesuffix('_ingestion')}_{version}_{col}"
    if len(full) <= 63:
        return full
    suffix = "_" + hashlib.md5(full.encode()).hexdigest()[:8]
    return full[:63 - len(suffix)] + suffix


def build_schema_sql(table: str, columns: list[str], version: str) -> str:
    col_defs = ',\n'.join(_column_definition(c) for c in columns)
    ddl = f"CREATE TABLE {table} (\n{col_defs}\n);"
    index_lines = [
        f"CREATE INDEX {_index_name(table, version, col)} ON {table} ({col});"
        for col in columns if col in _INDEX_COLUMNS
    ]
    parts = [ddl] + index_lines
    return '\n'.join(parts) + '\n'


def generate_missing_schemas(all_urls: list[dict], schema_dir: Path = SCHEMA_DIR) -> None:
    schema_dir.mkdir(exist_ok=True)

    seen: dict[str, str] = {}
    for row in all_urls:
        name = row["name"]
        table = f"{to_snake_case(name)}_ingestion"
        if not (schema_dir / f"{table}.sql").exists() and name not in seen:
            seen[name] = f"{BASE_URL}{row['csv_url']}"

    if not seen:
        return

    def _generate(name: str, csv_url: str) -> tuple[str, str, str, str]:
        snake_name = to_snake_case(name)
        table = f"{snake_name}_ingestion"
        version = csv_url[len(BASE_URL):].split("/")[5]
        columns = get_csv_column_names(csv_url)
        return table, build_schema_sql(table, columns, version), snake_name, version

    def _upsert(cur, snake_name: str, version: str) -> None:
        cur.execute(
            "UPDATE aws_pricing_list_versions SET version = %s WHERE name = %s",
            (version, snake_name),
        )
        if cur.rowcount == 0:
            cur.execute(
                "INSERT INTO aws_pricing_list_versions (name, version) VALUES (%s, %s)",
                (snake_name, version),
            )
        print(f"[DB] upserted aws_pricing_list_versions: name={snake_name} version={version}", file=sys.stderr)

    db_conn = None
    try:
        db_conn = psycopg2.connect(
            host=os.environ["POSTGRES_HOST"],
            port=int(os.environ.get("POSTGRES_PORT", 5432)),
            dbname=os.environ["POSTGRES_DB"],
            user=os.environ["POSTGRES_USER"],
            password=os.environ["POSTGRES_PASSWORD"],
        )
    except (KeyError, psycopg2.OperationalError) as e:
        print(f"[WARN] DB unavailable, skipping aws_pricing_list_versions upsert: {e}", file=sys.stderr)

    try:
        with ThreadPoolExecutor(max_workers=10) as executor:
            futures = {executor.submit(_generate, n, u): n for n, u in seen.items()}
            for future in as_completed(futures):
                try:
                    table, sql, snake_name, version = future.result()
                    (schema_dir / f"{table}.sql").write_text(sql)
                    print(f"[SCHEMA] generated schema/{table}.sql", file=sys.stderr)
                    if db_conn is not None:
                        with db_conn:
                            with db_conn.cursor() as cur:
                                _upsert(cur, snake_name, version)
                except Exception as e:
                    name = futures[future]
                    print(f"[WARN] schema generation failed for {name}: {e}", file=sys.stderr)
    finally:
        if db_conn is not None:
            db_conn.close()


if __name__ == "__main__":
    start = time.time()
    all_urls = get_all_pricing_urls()
    elapsed = time.time() - start

    schema_start = time.time()
    generate_missing_schemas(all_urls)
    schema_elapsed = time.time() - schema_start

    print("type,name,region,csv_url,publication_date")
    for row in all_urls:
        print(f"{row['type']},{row['name']},{row['region']},{BASE_URL}{row['csv_url']},{row['publication_date']}")

    service_count = sum(1 for r in all_urls if r["type"] == "service")
    sp_count = sum(1 for r in all_urls if r["type"] == "savings_plan")
    print(f"\n# Total: {len(all_urls)} rows ({service_count} service, {sp_count} savings_plan) in {elapsed:.2f}s (index) {schema_elapsed:.2f}s (schema)", file=sys.stderr)
