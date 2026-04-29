from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    postgres_host: str | None = None
    postgres_port: int = 5432
    postgres_db: str | None = None
    postgres_user: str | None = None
    postgres_password: str | None = None
    postgres_ssl_mode: str | None = None
    postgres_ssl_rootcert: str | None = None
    postgres_ssl_cert: str | None = None
    postgres_ssl_key: str | None = None

    model_config = SettingsConfigDict(env_file=".env")


settings = Settings()
