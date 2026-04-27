# AWS Pricing List Loader

Crawls the [AWS Pricing API](https://pricing.us-east-1.amazonaws.com) to discover all service and savings plan pricing URLs, generates PostgreSQL `CREATE TABLE` schemas from the CSV column headers, and outputs a CSV index of every pricing file.

## Usage

```bash
pip install requests
python fetch_pricing_index.py
```

Output (stdout) is a CSV with columns: `type, name, region, csv_url, publication_date`.

```bash
# Save the pricing index
python fetch_pricing_index.py > output.txt
```

Any AWS service not yet in `schema/` will have its DDL generated automatically during the run.

## What it does

1. Fetches the master service index to get region index URLs for every AWS service.
2. Fetches each region index in parallel to collect per-region versioned CSV URLs.
3. For any service without an existing schema, streams line 6 of its CSV (the header row) and writes a `schema/{service}_ingestion.sql` file.
4. Prints all discovered pricing URLs to stdout.

## Schema files

Generated DDL files live in `schema/` and are named `{service_name}_ingestion.sql`. Each file contains a `CREATE TABLE` statement and indexes on `sku`, `region_code`, and `discounted_region_code`.

To load a pricing CSV into Postgres, skip the first 6 header lines and use `COPY`:

```sql
COPY amazon_rds_ingestion FROM '/path/to/file.csv' CSV HEADER;
```

To regenerate a schema, delete the corresponding `.sql` file and re-run the script.

## References

See [references.md](references.md) for AWS Pricing API documentation links and JSON/CSV structure details.
