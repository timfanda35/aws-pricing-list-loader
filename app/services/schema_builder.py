import hashlib
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

import requests

from app.database import get_db_conn
from app.services.aws_client import BASE_URL, to_snake_case

SCHEMA_DIR = Path(__file__).parent.parent.parent / "schema"

_COLUMN_TYPE_MAPPINGS = {
    'effective_date': 'DATE',
    'lease_contract_length': 'INTEGER',
    'discounted_rate': 'DECIMAL(20,10)',
    'price_per_unit': 'DECIMAL(20,10)',
}
_INDEX_COLUMNS = {'sku', 'region_code', 'discounted_region_code'}


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
    ddl = f"CREATE TABLE IF NOT EXISTS {table} (\n{col_defs}\n);"
    index_lines = [
        f"CREATE INDEX {_index_name(table, version, col)} ON {table} ({col});"
        for col in columns if col in _INDEX_COLUMNS
    ]
    return '\n'.join([ddl] + index_lines) + '\n'


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
        db_conn = get_db_conn()
    except Exception as e:
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
