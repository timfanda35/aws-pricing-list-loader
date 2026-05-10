CREATE TABLE IF NOT EXISTS "AmazonPersonalize_ingestion" (
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
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "tier" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonPersonalize_20240507210355_sku ON "AmazonPersonalize_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonPersonalize_20240507210355_region_code ON "AmazonPersonalize_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonPersonalize_20240507210355_pricing_region ON "AmazonPersonalize_ingestion" ("pricing_region");
