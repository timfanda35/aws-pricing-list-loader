import psycopg2

from app.config import settings


def get_db_conn():
    if not all([settings.postgres_host, settings.postgres_db, settings.postgres_user, settings.postgres_password]):
        raise RuntimeError("Missing required PostgreSQL environment variables")
    ssl_kwargs = {}
    if settings.postgres_ssl_mode:
        ssl_kwargs["sslmode"] = settings.postgres_ssl_mode
    if settings.postgres_ssl_rootcert:
        ssl_kwargs["sslrootcert"] = settings.postgres_ssl_rootcert
    if settings.postgres_ssl_cert:
        ssl_kwargs["sslcert"] = settings.postgres_ssl_cert
    if settings.postgres_ssl_key:
        ssl_kwargs["sslkey"] = settings.postgres_ssl_key
    return psycopg2.connect(
        host=settings.postgres_host,
        port=settings.postgres_port,
        dbname=settings.postgres_db,
        user=settings.postgres_user,
        password=settings.postgres_password,
        **ssl_kwargs,
    )
