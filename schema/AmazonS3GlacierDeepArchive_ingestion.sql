CREATE TABLE IF NOT EXISTS "AmazonS3GlacierDeepArchive_ingestion" (
    "sku" TEXT,
    "offer_term_code" TEXT,
    "rate_code" TEXT,
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
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonS3GlacierDeepArchive_20260309224755_sku ON "AmazonS3GlacierDeepArchive_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonS3GlacierDeepArchive_20260309224755_region_code ON "AmazonS3GlacierDeepArchive_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonS3GlacierDeepArchive_20260309224755_pricing_region ON "AmazonS3GlacierDeepArchive_ingestion" ("pricing_region");
