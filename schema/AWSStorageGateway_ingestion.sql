CREATE TABLE IF NOT EXISTS "AWSStorageGateway_ingestion" (
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
    "storage_class" TEXT,
    "fee_code" TEXT,
    "fee_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "maximum_capacity" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "storage_description" TEXT,
    "version" TEXT
);
CREATE INDEX IF NOT EXISTS AWSStorageGateway_20251009170740_sku ON "AWSStorageGateway_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSStorageGateway_20251009170740_region_code ON "AWSStorageGateway_ingestion" ("region_code");
