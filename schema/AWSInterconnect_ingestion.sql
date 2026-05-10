CREATE TABLE IF NOT EXISTS "AWSInterconnect_ingestion" (
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
    "interconnect_region_billing_prefix" TEXT,
    "interconnect_region_name" TEXT,
    "interconnect_tier" TEXT,
    "partner_cloud_service_provider" TEXT,
    "partner_metro" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "to_region_name" TEXT,
    "traffic_direction" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AWSInterconnect_20260414235556_sku ON "AWSInterconnect_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSInterconnect_20260414235556_region_code ON "AWSInterconnect_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AWSInterconnect_20260414235556_pricing_region ON "AWSInterconnect_ingestion" ("pricing_region");
