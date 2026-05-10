CREATE TABLE IF NOT EXISTS "ContactLensAmazonConnect_ingestion" (
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
    "usage_type" TEXT,
    "operation" TEXT,
    "analytics_mode" TEXT,
    "analytics_type" TEXT,
    "max_package" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX IF NOT EXISTS ContactLensAmazonConnect_20250729201501_sku ON "ContactLensAmazonConnect_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS ContactLensAmazonConnect_20250729201501_region_code ON "ContactLensAmazonConnect_ingestion" ("region_code");
