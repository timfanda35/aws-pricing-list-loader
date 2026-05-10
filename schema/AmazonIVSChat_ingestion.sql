CREATE TABLE IF NOT EXISTS "AmazonIVSChat_ingestion" (
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
    "message_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonIVSChat_20241211154214_sku ON "AmazonIVSChat_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonIVSChat_20241211154214_region_code ON "AmazonIVSChat_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonIVSChat_20241211154214_pricing_region ON "AmazonIVSChat_ingestion" ("pricing_region");
