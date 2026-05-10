CREATE TABLE IF NOT EXISTS "AmazonKinesisVideo_ingestion" (
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
    "description" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "group" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "consumption_type" TEXT,
    "read_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "tier" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonKinesisVideo_20260428201033_sku ON "AmazonKinesisVideo_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonKinesisVideo_20260428201033_region_code ON "AmazonKinesisVideo_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonKinesisVideo_20260428201033_pricing_region ON "AmazonKinesisVideo_ingestion" ("pricing_region");
