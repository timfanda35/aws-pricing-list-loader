# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install runtime + dev dependencies (for local development)
pip install -r requirements-dev.txt

# Start the API server (local dev)
uvicorn app.main:app --reload

# Run unit and API tests (no DB or network required)
pytest tests/

# Run integration tests (requires live PostgreSQL)
pytest test_create_table.py

# CLI — list all pricing URLs and generate missing schema files
python fetch_pricing_index.py

# CLI — load all pricing data into PostgreSQL
python fetch_pricing_index.py --load

# CLI — load a single service or savings plan (for testing)
python fetch_pricing_index.py --load --name comprehend
python fetch_pricing_index.py --load --name AWSDatabaseSavingsPlans
```

```bash
# Docker — build and start the full stack (DB + API)
docker compose up --build -d

# Docker — view logs
docker compose logs -f api

# Docker — tear down
docker compose down
```

PostgreSQL connection is configured via env vars (see `.env.example`): `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`. Managed by `app/config.py` using `pydantic-settings`.

## Architecture

A FastAPI HTTP service backed by a modular service layer. The CLI (`fetch_pricing_index.py`) and the API share the same service layer — no logic duplication.

```
app/
├── main.py              # FastAPI app + router registration
├── config.py            # pydantic-settings Settings (env vars)
├── database.py          # psycopg2 connection factory
├── routers/
│   ├── pricing.py       # GET /pricing/urls, POST /pricing/load
│   └── versions.py      # GET /versions
└── services/
    ├── aws_client.py    # AWS Pricing API fetching, to_snake_case, BASE_URL
    ├── schema_builder.py# DDL generation, generate_missing_schemas
    └── loader.py        # Ingestion/swap logic, load_pricing_data
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/health` | Liveness check; returns `{"status": "ok"}` |
| `GET` | `/pricing/urls` | List all pricing URLs; generates missing schema files |
| `POST` | `/pricing/load` | Load pricing data into DB (blocking); optional `{"name": "..."}` body |
| `GET` | `/versions` | List loaded service versions from `aws_pricing_list_versions` |

## Data Flow — URL listing mode

1. **Service index** — Fetches `https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/index.json` to get all AWS services and their region index URLs.
2. **Region index per service** — Fetches each service's `region_index.json` to get per-region versioned CSV URLs. Savings Plans (3 hardcoded paths) follow a slightly different JSON structure (`regions[]` array vs object).
3. **CSV schema generation** — For each service/savings-plan not yet in `schema/`, fetches line 6 of the CSV (streaming, no full download) to read column headers, converts them to snake_case, then writes a `CREATE TABLE` + `CREATE INDEX` DDL to `schema/{table}_ingestion.sql`.
4. **Output** — Returns/prints all discovered pricing URLs (type, name, region, csv_url, publication_date).

## Data Flow — load mode

1. **Version check** — Loads `(name, version)` pairs from `aws_pricing_list_versions`; skips any region whose version is already recorded.
2. **Create ingestion table** — For each service with new data, generates DDL via `build_schema_sql()` and executes it directly to the DB (`DROP … CASCADE` then `CREATE TABLE` + `CREATE INDEX`). No schema file is read or written.
3. **Download & load** — Streams each region CSV, skips the first 6 lines (5 metadata + 1 header), writes data rows to a temp file, then `COPY … FROM STDIN` into the ingestion table. Temp file is deleted immediately after.
4. **Table swap** — After all regions for a service are loaded: renames the existing production table to `drop_{name}`, renames `{name}_ingestion` to `{name}`, then drops `drop_{name}`. First-run safe (`ALTER TABLE IF EXISTS`).
5. **Version record** — Upserts the loaded `(name, version)` into `aws_pricing_list_versions`.

## Schema Generation Rules

- Table name: `{snake_case(service_name)}_ingestion`
- Column types: most columns are `TEXT`; overrides in `_COLUMN_TYPE_MAPPINGS` in `schema_builder.py` (e.g., `price_per_unit` → `DECIMAL(20,10)`, `effective_date` → `DATE`)
- `rate_code` gets `PRIMARY KEY`
- `sku`, `region_code`, `discounted_region_code` get indexes; index names are capped at 63 chars (PostgreSQL limit) with MD5 hash suffix if needed
- In load mode, DDL is executed directly to the DB; in listing mode, DDL is written to `schema/`

## Key Constants

- `BASE_URL` — `https://pricing.us-east-1.amazonaws.com` (in `app/services/aws_client.py`)
- `SCHEMA_DIR` — `./schema/` (in `app/services/schema_builder.py`)
- CSV line 6 (0-indexed line 5) contains column headers; first 5 lines are AWS metadata

## Container files

| File | Purpose |
|------|---------|
| `Dockerfile` | Multi-stage build: builder installs deps into `/opt/venv`; runtime stage copies venv + app, runs as non-root `appuser` |
| `docker-entrypoint.sh` | Runs `create_table.py` (idempotent) then `exec`s uvicorn for signal-safe startup |
| `.dockerignore` | Excludes `.env`, `schema/`, `tests/`, dev files from the image |
| `requirements.txt` | Runtime-only pinned deps (used by Dockerfile) |
| `requirements-dev.txt` | Runtime + dev/test deps (pytest, httpx); used for local development |

`docker compose up --build -d` starts both `db` (postgres:17) and `api`. The `api` service waits for the DB healthcheck (`pg_isready`) before starting. `POSTGRES_HOST` is overridden to `db` (the compose service name) inside the container.

## files/ directory

Contains sample cached files used for reference during development (region index JSON, sample CSVs). Not used at runtime.
