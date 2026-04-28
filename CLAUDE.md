# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# List all pricing URLs and generate missing schema files
python fetch_pricing_index.py

# Capture URL index to file
python fetch_pricing_index.py > output.txt

# Load all pricing data into PostgreSQL
python fetch_pricing_index.py --load

# Load a single service or savings plan (for testing)
python fetch_pricing_index.py --load --name comprehend
python fetch_pricing_index.py --load --name AWSDatabaseSavingsPlans
```

Dependencies: `requests`, `psycopg2-binary`, `python-dotenv` (`pip install requests psycopg2-binary python-dotenv`)

PostgreSQL connection is configured via env vars (see `.env.example`): `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`.

## Architecture

This is a single-script tool ([fetch_pricing_index.py](fetch_pricing_index.py)) that crawls the AWS Pricing API, generates PostgreSQL DDL on-the-fly, and bulk-loads pricing CSVs into PostgreSQL.

### Data Flow — URL listing mode (default)

1. **Service index** — Fetches `https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/index.json` to get all AWS services and their region index URLs.
2. **Region index per service** — Fetches each service's `region_index.json` to get per-region versioned CSV URLs. Savings Plans (3 hardcoded paths) follow a slightly different JSON structure (`regions[]` array vs object).
3. **CSV schema generation** — For each service/savings-plan not yet in `schema/`, fetches line 6 of the CSV (streaming, no full download) to read column headers, converts them to snake_case, then writes a `CREATE TABLE` + `CREATE INDEX` DDL to `schema/{table}_ingestion.sql`.
4. **Output** — Prints a CSV of all discovered pricing URLs to stdout (type, name, region, csv_url, publication_date).

### Data Flow — `--load` mode

1. **Version check** — Loads `(name, version)` pairs from `aws_pricing_list_versions`; skips any region whose version is already recorded.
2. **Create ingestion table** — For each service with new data, generates DDL via `build_schema_sql()` and executes it directly to the DB (`DROP … CASCADE` then `CREATE TABLE` + `CREATE INDEX`). No schema file is read or written.
3. **Download & load** — Streams each region CSV, skips the first 6 lines (5 metadata + 1 header), writes data rows to a temp file, then `COPY … FROM STDIN` into the ingestion table. Temp file is deleted immediately after.
4. **Table swap** — After all regions for a service are loaded: renames the existing production table to `drop_{name}`, renames `{name}_ingestion` to `{name}`, then drops `drop_{name}`. First-run safe (`ALTER TABLE IF EXISTS`).
5. **Version record** — Upserts the loaded `(name, version)` into `aws_pricing_list_versions`.

### Schema Generation Rules

- Table name: `{snake_case(service_name)}_ingestion`
- Column types: most columns are `TEXT`; overrides in `_COLUMN_TYPE_MAPPINGS` (e.g., `price_per_unit` → `DECIMAL(20,10)`, `effective_date` → `DATE`)
- `rate_code` gets `PRIMARY KEY`
- `sku`, `region_code`, `discounted_region_code` get indexes; index names are capped at 63 chars (PostgreSQL limit) with MD5 hash suffix if needed
- In `--load` mode, DDL is executed directly to the DB; in listing mode, DDL is written to `schema/`

### Key Constants

- `BASE_URL` — `https://pricing.us-east-1.amazonaws.com`
- `SCHEMA_DIR` — `./schema/`
- CSV line 6 (0-indexed line 5) contains column headers; first 5 lines are AWS metadata

### files/ directory

Contains sample cached files used for reference during development (region index JSON, sample CSVs). Not used by the script at runtime.
