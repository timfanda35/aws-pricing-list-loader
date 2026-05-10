CREATE TABLE IF NOT EXISTS "AmazonMSK_ingestion" (
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
    "description" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "v_cpu" TEXT,
    "group" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "compute_family" TEXT,
    "memory_gi_b" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "storage_family" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonMSK_20260422040553_sku ON "AmazonMSK_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonMSK_20260422040553_region_code ON "AmazonMSK_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonMSK_20260422040553_pricing_region ON "AmazonMSK_ingestion" ("pricing_region");
