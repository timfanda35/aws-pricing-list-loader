CREATE TABLE IF NOT EXISTS "AWSServiceCatalog_ingestion" (
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
    "region_code" TEXT,
    "service_name" TEXT,
    "type" TEXT,
    "with_active_users" TEXT
);
CREATE INDEX IF NOT EXISTS AWSServiceCatalog_20260504202234_sku ON "AWSServiceCatalog_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSServiceCatalog_20260504202234_region_code ON "AWSServiceCatalog_ingestion" ("region_code");
