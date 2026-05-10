CREATE TABLE IF NOT EXISTS "AWSXRay_ingestion" (
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
    "related_to" TEXT,
    "product_family" TEXT,
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "group" TEXT,
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AWSXRay_20250828153810_sku ON "AWSXRay_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSXRay_20250828153810_region_code ON "AWSXRay_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AWSXRay_20250828153810_pricing_region ON "AWSXRay_ingestion" ("pricing_region");
