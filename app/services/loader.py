import os
import sys
import tempfile
import time
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor, as_completed

import requests

from app.database import get_db_conn
from app.services.aws_client import BASE_URL, get_all_pricing_urls, to_snake_case
from app.services.schema_builder import build_schema_sql, get_csv_column_names


def load_known_versions() -> frozenset[tuple[str, str]]:
    try:
        conn = get_db_conn()
        try:
            with conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT name, version FROM aws_pricing_list_versions")
                    return frozenset(cur.fetchall())
        finally:
            conn.close()
    except Exception as e:
        print(f"[WARN] DB unavailable, skipping version filter: {e}", file=sys.stderr)
        return frozenset()


def get_all_versions() -> list[dict]:
    conn = get_db_conn()
    try:
        with conn:
            with conn.cursor() as cur:
                cur.execute("SELECT name, version FROM aws_pricing_list_versions ORDER BY name")
                return [{"name": row[0], "version": row[1]} for row in cur.fetchall()]
    finally:
        conn.close()


def _create_ingestion_table(conn, ingestion_table: str, csv_url: str, version: str) -> list[str]:
    columns = get_csv_column_names(f"{BASE_URL}{csv_url}")
    ddl = build_schema_sql(ingestion_table, columns, version)
    with conn.cursor() as cur:
        cur.execute(f'DROP TABLE IF EXISTS "{ingestion_table}" CASCADE')
        for stmt in ddl.split(";\n"):
            stmt = stmt.strip()
            if stmt:
                cur.execute(stmt)
        cur.execute(
            "SELECT column_name FROM information_schema.columns"
            " WHERE table_name = %s AND table_schema = 'public'"
            " ORDER BY ordinal_position",
            (ingestion_table,),
        )
        ordered_columns = [row[0] for row in cur.fetchall()]
    conn.commit()
    return ordered_columns


def _download_csv_strip_header(csv_url: str, dest_path: str) -> int:
    row_count = 0
    with requests.get(f"{BASE_URL}{csv_url}", stream=True) as resp:
        resp.raise_for_status()
        with open(dest_path, "wb") as f:
            for i, line in enumerate(resp.iter_lines()):
                if i < 6:
                    continue
                f.write(line + b"\n")
                row_count += 1
    return row_count


def _copy_csv_to_table(conn, ingestion_table: str, columns: list[str], csv_path: str) -> None:
    col_list = ", ".join(f'"{c}"' for c in columns)
    sql = f'COPY "{ingestion_table}" ({col_list}) FROM STDIN WITH (FORMAT CSV, QUOTE \'"\');'
    with open(csv_path, "rb") as f:
        with conn.cursor() as cur:
            cur.copy_expert(sql, f)
    conn.commit()


def _swap_tables(conn, ingestion_table: str) -> None:
    target = ingestion_table.removesuffix("_ingestion")
    drop_target = f"drop_{target}"
    with conn.cursor() as cur:
        cur.execute(f'ALTER TABLE IF EXISTS "{target}" RENAME TO "{drop_target}"')
        cur.execute(f'ALTER TABLE "{ingestion_table}" RENAME TO "{target}"')
    conn.commit()
    with conn.cursor() as cur:
        cur.execute(f'DROP TABLE IF EXISTS "{drop_target}"')
    conn.commit()


def _upsert_version(conn, snake_name: str, version: str) -> None:
    with conn.cursor() as cur:
        cur.execute(
            "UPDATE aws_pricing_list_versions SET version = %s WHERE name = %s",
            (version, snake_name),
        )
        if cur.rowcount == 0:
            cur.execute(
                "INSERT INTO aws_pricing_list_versions (name, version) VALUES (%s, %s)",
                (snake_name, version),
            )
    conn.commit()


def _process_pricing_group(rows: list[dict]) -> tuple[str, int]:
    name = rows[0]["name"]
    snake_name = to_snake_case(name)
    ingestion_table = f"{snake_name}_ingestion"
    regions_loaded = 0

    conn = get_db_conn()
    try:
        version = rows[0]["csv_url"].split("/")[5]
        columns = _create_ingestion_table(conn, ingestion_table, rows[0]["csv_url"], version)
        print(f"[TABLE] created {ingestion_table}", file=sys.stderr)

        seen_versions: set[str] = set()
        for row in rows:
            csv_url = row["csv_url"]
            region = row["region"]
            row_version = csv_url.split("/")[5]
            tmp_path = None
            try:
                with tempfile.NamedTemporaryFile(suffix=".csv", delete=False) as tmp:
                    tmp_path = tmp.name
                count = _download_csv_strip_header(csv_url, tmp_path)
                _copy_csv_to_table(conn, ingestion_table, columns, tmp_path)
                print(f"[COPY] {name}/{region} → {ingestion_table} ({count} rows)", file=sys.stderr)
                regions_loaded += 1
                seen_versions.add(row_version)
            except Exception as e:
                conn.rollback()
                print(f"[ERROR] {name}/{region}: {e}", file=sys.stderr)
            finally:
                if tmp_path and os.path.exists(tmp_path):
                    os.remove(tmp_path)

        if regions_loaded > 0:
            _swap_tables(conn, ingestion_table)
            print(f"[SWAP] {ingestion_table} → {snake_name}", file=sys.stderr)
            for v in seen_versions:
                _upsert_version(conn, snake_name, v)
                print(f"[VERSION] {snake_name} = {v}", file=sys.stderr)
        else:
            print(f"[SKIP] {name}: no regions loaded successfully", file=sys.stderr)
    finally:
        conn.close()

    return snake_name, regions_loaded


def load_pricing_data(name_filter: str | None = None) -> dict:
    start = time.time()
    known_versions = load_known_versions()
    all_rows = get_all_pricing_urls(known_versions)

    groups: dict[str, list[dict]] = defaultdict(list)
    for row in all_rows:
        if name_filter is None or row["name"] == name_filter:
            groups[row["name"]].append(row)

    if not groups:
        print("[INFO] Nothing new to load.", file=sys.stderr)
        return {"loaded": 0, "services": 0, "elapsed_seconds": round(time.time() - start, 2)}

    total_regions = 0
    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = {executor.submit(_process_pricing_group, rows): name for name, rows in groups.items()}
        for future in as_completed(futures):
            try:
                _, count = future.result()
                total_regions += count
            except Exception as e:
                print(f"[ERROR] group failed: {e}", file=sys.stderr)

    elapsed = round(time.time() - start, 2)
    return {"loaded": total_regions, "services": len(groups), "elapsed_seconds": elapsed}
