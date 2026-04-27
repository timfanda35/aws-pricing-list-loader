CREATE TABLE amazon_mwaa_ingestion (
    "sku" TEXT,
    "offer_term_code" TEXT,
    "rate_code" TEXT PRIMARY KEY,
    "term_type" TEXT,
    "price_description" TEXT,
    "effective_date" DATE,
    "starting_range" TEXT,
    "ending_range" TEXT,
    "unit" TEXT,
    "price_per_unit" DECIMAL(20,10),
    "currency" TEXT,
    "product_family" TEXT,
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "mwaa_serverless_task_types" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "size" TEXT,
    "type" TEXT,
    "version" TEXT
);
CREATE INDEX amazon_mwaa_20260420214526_sku ON amazon_mwaa_ingestion (sku);
CREATE INDEX amazon_mwaa_20260420214526_region_code ON amazon_mwaa_ingestion (region_code);
