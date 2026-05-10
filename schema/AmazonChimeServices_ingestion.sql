CREATE TABLE IF NOT EXISTS "AmazonChimeServices_ingestion" (
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
    "usage_type" TEXT,
    "operation" TEXT,
    "license_type" TEXT,
    "primary_place_of_use" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "transaction_type" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonChimeServices_20241219235601_sku ON "AmazonChimeServices_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonChimeServices_20241219235601_region_code ON "AmazonChimeServices_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonChimeServices_20241219235601_pricing_region ON "AmazonChimeServices_ingestion" ("pricing_region");
