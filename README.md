# AWS Pricing List Loader

Crawls the [AWS Pricing API](https://pricing.us-east-1.amazonaws.com) to discover all service and savings plan pricing URLs, and bulk-loads every region's pricing CSV into PostgreSQL using an ingestion/swap pattern.

Exposed as a FastAPI HTTP service, with a CLI available for local use.

## Setup

### Docker (recommended)

```bash
cp .env.example .env  # fill in Postgres credentials
docker compose up --build -d
```

Starts both PostgreSQL and the API. The API container automatically creates the `aws_pricing_list_versions` table on first start. Interactive docs at `http://localhost:8000/docs`.

### Local development

```bash
pip install -r requirements-dev.txt
cp .env.example .env  # fill in Postgres credentials
docker compose up -d db  # start Postgres only
python create_table.py   # create aws_pricing_list_versions table
uvicorn app.main:app --reload
```

## API

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/health` | Liveness check — returns `{"status":"ok"}` |
| `GET` | `/pricing/urls` | List all discovered pricing URLs; generates any missing schema files |
| `POST` | `/pricing/load` | Load pricing data into PostgreSQL (blocks until complete) |
| `GET` | `/versions` | List all loaded service versions |

`POST /pricing/load` accepts an optional JSON body to target a single service:

```json
{ "name": "comprehend" }
```

Response:

```json
{ "loaded": 14, "services": 1, "elapsed_seconds": 42.3 }
```

## CLI

The CLI shares the same service layer as the API.

### List pricing URLs

```bash
python fetch_pricing_index.py
python fetch_pricing_index.py > output.txt  # save to file
```

Output (stdout) is a CSV with columns: `type, name, region, csv_url, publication_date`.

### Load pricing data into PostgreSQL

```bash
python fetch_pricing_index.py --load
python fetch_pricing_index.py --load --name comprehend
python fetch_pricing_index.py --load --name AWSDatabaseSavingsPlans
```

Already-loaded versions are skipped automatically (tracked in `aws_pricing_list_versions`).

## How loading works

For each service with new data:

1. Generates a `CREATE TABLE` schema from the CSV header row and executes it directly to the DB.
2. Streams each region's CSV, strips the first 6 lines (metadata + header), and bulk-loads the data via `COPY … FROM STDIN`.
3. Atomically swaps the ingestion table into production: renames the existing `{service}` table to `drop_{service}`, renames `{service}_ingestion` to `{service}`, then drops `drop_{service}`.
4. Records the loaded version in `aws_pricing_list_versions` so subsequent runs skip it.

## Schema files

Schema files in `schema/` are generated during URL listing (both CLI listing mode and `GET /pricing/urls`). Each file (`{service}_ingestion.sql`) contains a `CREATE TABLE` + index DDL. In `--load` mode the DDL is generated on-the-fly and executed directly.

To force schema regeneration, delete the corresponding `.sql` file and re-run in listing mode.

## Testing

### Unit and API tests

No database or network connection required:

```bash
pip install -r requirements-dev.txt
pytest tests/
```

Covers:
- `tests/test_aws_client.py` — `to_snake_case` with real AWS service names
- `tests/test_schema_builder.py` — column type overrides, index name truncation, DDL generation
- `tests/test_api.py` — all three endpoints via FastAPI `TestClient` with mocked service layer

### Integration tests

Requires a running PostgreSQL instance (`.env` configured):

```bash
pytest test_create_table.py
```

### Manual smoke tests

Smoke test a savings plan:

```bash
psql -c "DELETE FROM aws_pricing_list_versions WHERE name = 'aws_database_savings_plans';"
python fetch_pricing_index.py --load --name AWSDatabaseSavingsPlans
# Expected: [TABLE] created → [COPY] 36 regions → [SWAP] → [VERSION]
```

Smoke test a service:

```bash
psql -c "DELETE FROM aws_pricing_list_versions WHERE name = 'comprehend';"
python fetch_pricing_index.py --load --name comprehend
# Expected: [TABLE] created → [COPY] 14 regions → [SWAP] → [VERSION]
```

## References

See [references.md](references.md) for AWS Pricing API documentation links and JSON/CSV structure details.
