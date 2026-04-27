# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the main script (fetches all pricing URLs and generates missing schemas)
python fetch_pricing_index.py

# Capture output to file
python fetch_pricing_index.py > output.txt
```

Dependencies: `requests` (`pip install requests`)

## Architecture

This is a single-script tool ([fetch_pricing_index.py](fetch_pricing_index.py)) that crawls the AWS Pricing API and generates PostgreSQL DDL for loading pricing data.

### Data Flow

1. **Service index** — Fetches `https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/index.json` to get all AWS services and their region index URLs.
2. **Region index per service** — Fetches each service's `region_index.json` to get per-region versioned CSV URLs. Savings Plans (3 hardcoded paths) follow a slightly different JSON structure (`regions[]` array vs object).
3. **CSV schema generation** — For each service/savings-plan not yet in `schema/`, fetches line 6 of the CSV (streaming, no full download) to read column headers, converts them to snake_case, then writes a `CREATE TABLE` + `CREATE INDEX` DDL to `schema/{table}_ingestion.sql`.
4. **Output** — Prints a CSV of all discovered pricing URLs to stdout (type, name, region, csv_url, publication_date).

### Schema Generation Rules

- Table name: `{snake_case(service_name)}_ingestion`
- Column types: most columns are `TEXT`; overrides in `_COLUMN_TYPE_MAPPINGS` (e.g., `price_per_unit` → `DECIMAL(20,10)`, `effective_date` → `DATE`)
- `rate_code` gets `PRIMARY KEY`
- `sku`, `region_code`, `discounted_region_code` get indexes; index names are capped at 63 chars (PostgreSQL limit) with MD5 hash suffix if needed
- Schemas are only generated for services not already present in `schema/`; delete a `.sql` file to regenerate it

### Key Constants

- `BASE_URL` — `https://pricing.us-east-1.amazonaws.com`
- `SCHEMA_DIR` — `./schema/`
- CSV line 6 (0-indexed line 5) contains column headers; first 5 lines are AWS metadata

### files/ directory

Contains sample cached files used for reference during development (region index JSON, sample CSVs). Not used by the script at runtime.
