CREATE TABLE IF NOT EXISTS "AmazonHealthLake_ingestion" (
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
    "bundle" TEXT,
    "data_type" TEXT,
    "input_type" TEXT,
    "nlp_class" TEXT,
    "notification_channel" TEXT,
    "query_type" TEXT,
    "region_code" TEXT,
    "resource_import" TEXT,
    "service_name" TEXT,
    "storage_class" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonHealthLake_20260203192959_sku ON "AmazonHealthLake_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonHealthLake_20260203192959_region_code ON "AmazonHealthLake_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonHealthLake_20260203192959_pricing_region ON "AmazonHealthLake_ingestion" ("pricing_region");
