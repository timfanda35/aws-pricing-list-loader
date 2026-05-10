CREATE TABLE IF NOT EXISTS "SnowballExtraDays_ingestion" (
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
    "fee_code" TEXT,
    "fee_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "snowball_type" TEXT
);
CREATE INDEX IF NOT EXISTS SnowballExtraDays_20241227192335_sku ON "SnowballExtraDays_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS SnowballExtraDays_20241227192335_region_code ON "SnowballExtraDays_ingestion" ("region_code");
