CREATE TABLE IF NOT EXISTS "AmazonGlacier_ingestion" (
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
    "availability" TEXT,
    "volume_type" TEXT,
    "fee_code" TEXT,
    "fee_description" TEXT,
    "group" TEXT,
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "durability" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonGlacier_20221116002454_sku ON "AmazonGlacier_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonGlacier_20221116002454_region_code ON "AmazonGlacier_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonGlacier_20221116002454_pricing_region ON "AmazonGlacier_ingestion" ("pricing_region");
