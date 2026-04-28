from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    postgres_host: str | None = None
    postgres_port: int = 5432
    postgres_db: str | None = None
    postgres_user: str | None = None
    postgres_password: str | None = None

    model_config = SettingsConfigDict(env_file=".env")


settings = Settings()
