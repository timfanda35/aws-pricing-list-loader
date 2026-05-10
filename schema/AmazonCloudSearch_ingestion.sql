CREATE TABLE IF NOT EXISTS "AmazonCloudSearch_ingestion" (
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
    "instance_type" TEXT,
    "group" TEXT,
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "cloud_search_version" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonCloudSearch_20221122170456_sku ON "AmazonCloudSearch_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonCloudSearch_20221122170456_region_code ON "AmazonCloudSearch_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonCloudSearch_20221122170456_pricing_region ON "AmazonCloudSearch_ingestion" ("pricing_region");
