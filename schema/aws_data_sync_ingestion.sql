CREATE TABLE aws_data_sync_ingestion (
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
    "product_schema_description" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "task_mode" TEXT,
    "task_type" TEXT
);
CREATE INDEX aws_data_sync_20250925180219_sku ON aws_data_sync_ingestion (sku);
CREATE INDEX aws_data_sync_20250925180219_region_code ON aws_data_sync_ingestion (region_code);
