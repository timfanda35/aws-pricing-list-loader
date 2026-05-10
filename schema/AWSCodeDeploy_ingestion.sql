CREATE TABLE IF NOT EXISTS "AWSCodeDeploy_ingestion" (
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
    "deployment_location" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX IF NOT EXISTS AWSCodeDeploy_20240821174641_sku ON "AWSCodeDeploy_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSCodeDeploy_20240821174641_region_code ON "AWSCodeDeploy_ingestion" ("region_code");
