CREATE TABLE amazon_kinesis_ingestion (
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
    "description" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "group" TEXT,
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "kinesis_advantage_operation" TEXT,
    "maximum_extended_storage" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "standard_storage_retention_included" TEXT
);
CREATE INDEX amazon_kinesis_20251118005655_sku ON amazon_kinesis_ingestion (sku);
CREATE INDEX amazon_kinesis_20251118005655_region_code ON amazon_kinesis_ingestion (region_code);
