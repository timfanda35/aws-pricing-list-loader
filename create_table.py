import sys

from app.database import get_db_conn

_CREATE_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS aws_pricing_list_versions (
    id      SERIAL PRIMARY KEY,
    name    TEXT,
    version TEXT
);
"""


def main():
    conn = get_db_conn()
    try:
        with conn:
            with conn.cursor() as cur:
                cur.execute(_CREATE_TABLE_SQL)
        print("Table 'aws_pricing_list_versions' created (or already exists).")
    finally:
        conn.close()


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
