CREATE TABLE IF NOT EXISTS "AWSAmplify_ingestion" (
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
    "product_family" TEXT,
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "storage" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "data_transfer_out" TEXT,
    "instance_type" TEXT,
    "region_code" TEXT,
    "request_count" TEXT,
    "request_duration" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AWSAmplify_20250620171023_sku ON "AWSAmplify_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSAmplify_20250620171023_region_code ON "AWSAmplify_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AWSAmplify_20250620171023_pricing_region ON "AWSAmplify_ingestion" ("pricing_region");
