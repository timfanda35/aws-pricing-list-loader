import os
import psycopg2
import pytest
from dotenv import load_dotenv

load_dotenv()


def get_conn():
    return psycopg2.connect(
        host=os.environ["POSTGRES_HOST"],
        port=int(os.environ.get("POSTGRES_PORT", 5432)),
        dbname=os.environ["POSTGRES_DB"],
        user=os.environ["POSTGRES_USER"],
        password=os.environ["POSTGRES_PASSWORD"],
    )


def test_table_exists_with_correct_schema():
    conn = get_conn()
    cur = conn.cursor()

    cur.execute("""
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_name = 'aws_pricing_list_versions'
        ORDER BY ordinal_position
    """)
    rows = cur.fetchall()
    cur.close()
    conn.close()

    assert len(rows) == 3, f"Expected 3 columns, got {len(rows)}: {rows}"

    col_map = {r[0]: (r[1], r[2]) for r in rows}

    assert "id" in col_map, "Missing column: id"
    assert "name" in col_map, "Missing column: name"
    assert "version" in col_map, "Missing column: version"

    assert col_map["name"] == ("text", "YES"), f"name column wrong: {col_map['name']}"
    assert col_map["version"] == ("text", "YES"), f"version column wrong: {col_map['version']}"
