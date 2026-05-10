CREATE TABLE IF NOT EXISTS "AmazonInspectorV2_ingestion" (
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
    "description" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "free_usage_included" TEXT,
    "region_code" TEXT,
    "scan_type" TEXT,
    "service_name" TEXT,
    "usage_volume" TEXT
);
CREATE INDEX IF NOT EXISTS AmazonInspectorV2_20260428193650_sku ON "AmazonInspectorV2_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonInspectorV2_20260428193650_region_code ON "AmazonInspectorV2_ingestion" ("region_code");
