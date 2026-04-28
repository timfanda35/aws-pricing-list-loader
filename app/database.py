import psycopg2

from app.config import settings


def get_db_conn():
    if not all([settings.postgres_host, settings.postgres_db, settings.postgres_user, settings.postgres_password]):
        raise RuntimeError("Missing required PostgreSQL environment variables")
    return psycopg2.connect(
        host=settings.postgres_host,
        port=settings.postgres_port,
        dbname=settings.postgres_db,
        user=settings.postgres_user,
        password=settings.postgres_password,
    )
