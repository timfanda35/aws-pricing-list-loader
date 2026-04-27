CREATE TABLE aws_code_pipeline_ingestion (
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
    "related_to" TEXT,
    "product_family" TEXT,
    "service_code" TEXT,
    "description" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX aws_code_pipeline_20240808221440_sku ON aws_code_pipeline_ingestion (sku);
CREATE INDEX aws_code_pipeline_20240808221440_region_code ON aws_code_pipeline_ingestion (region_code);
