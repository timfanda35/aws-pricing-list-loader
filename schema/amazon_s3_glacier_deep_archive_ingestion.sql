CREATE TABLE amazon_s3_glacier_deep_archive_ingestion (
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
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "storage_class" TEXT,
    "volume_type" TEXT,
    "fee_code" TEXT,
    "fee_description" TEXT,
    "group" TEXT,
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_s3_glacier_deep_archive_20260309224755_sku ON amazon_s3_glacier_deep_archive_ingestion (sku);
CREATE INDEX amazon_s3_glacier_deep_archive_20260309224755_region_code ON amazon_s3_glacier_deep_archive_ingestion (region_code);
