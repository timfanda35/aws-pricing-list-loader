from pathlib import Path

from app.database import get_db_conn

MIGRATIONS_DIR = Path(__file__).parent.parent / "migrations"

_CREATE_TRACKING_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS schema_migrations (
    version    TEXT PRIMARY KEY,
    applied_at TIMESTAMP DEFAULT NOW()
);
"""

_GET_APPLIED_SQL = "SELECT version FROM schema_migrations;"

_RECORD_MIGRATION_SQL = "INSERT INTO schema_migrations (version) VALUES (%s);"


def run_migrations():
    conn = get_db_conn()
    try:
        with conn:
            with conn.cursor() as cur:
                cur.execute(_CREATE_TRACKING_TABLE_SQL)
                cur.execute(_GET_APPLIED_SQL)
                applied = {row[0] for row in cur.fetchall()}

        for sql_file in sorted(MIGRATIONS_DIR.glob("*.sql")):
            if sql_file.name in applied:
                continue
            sql = sql_file.read_text()
            with conn:
                with conn.cursor() as cur:
                    cur.execute(sql)
                    cur.execute(_RECORD_MIGRATION_SQL, (sql_file.name,))
            print(f"Applied migration: {sql_file.name}")
    finally:
        conn.close()
