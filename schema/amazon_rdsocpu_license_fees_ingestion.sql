CREATE TABLE amazon_rdsocpu_license_fees_ingestion (
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
    "database_edition" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "license_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_rdsocpu_license_fees_20260422000108_sku ON amazon_rdsocpu_license_fees_ingestion (sku);
CREATE INDEX amazon_rdsocpu_license_fees_20260422000108_region_code ON amazon_rdsocpu_license_fees_ingestion (region_code);
