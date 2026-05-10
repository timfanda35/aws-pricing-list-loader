CREATE TABLE IF NOT EXISTS "AmazonHoneycode_ingestion" (
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
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "tier" TEXT,
    "usage_tier" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonHoneycode_20230824190041_sku ON "AmazonHoneycode_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonHoneycode_20230824190041_region_code ON "AmazonHoneycode_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonHoneycode_20230824190041_pricing_region ON "AmazonHoneycode_ingestion" ("pricing_region");
