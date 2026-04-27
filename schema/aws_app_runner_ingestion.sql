CREATE TABLE aws_app_runner_ingestion (
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
    "build" TEXT,
    "cpu_tupe" TEXT,
    "gb" TEXT,
    "pipeline" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "type" TEXT
);
CREATE INDEX aws_app_runner_20240126165719_sku ON aws_app_runner_ingestion (sku);
CREATE INDEX aws_app_runner_20240126165719_region_code ON aws_app_runner_ingestion (region_code);
