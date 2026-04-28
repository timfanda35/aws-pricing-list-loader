import os
import sys
import psycopg2
from dotenv import load_dotenv

load_dotenv()

_CREATE_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS aws_pricing_list_versions (
    id      SERIAL PRIMARY KEY,
    name    TEXT,
    version TEXT
);
"""


def main():
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
                cur.execute(_CREATE_TABLE_SQL)
        print("Table 'aws_pricing_list_versions' created (or already exists).")
    finally:
        conn.close()


if __name__ == "__main__":
    try:
        main()
    except KeyError as e:
        print(f"Missing environment variable: {e}", file=sys.stderr)
        sys.exit(1)
    except psycopg2.OperationalError as e:
        print(f"Database connection failed: {e}", file=sys.stderr)
        sys.exit(1)
