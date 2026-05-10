CREATE TABLE IF NOT EXISTS "AmazonDAX_ingestion" (
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
    "instance_type" TEXT,
    "current_generation" TEXT,
    "instance_family" TEXT,
    "v_cpu" TEXT,
    "memory" TEXT,
    "network_performance" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonDAX_20250430174354_sku ON "AmazonDAX_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonDAX_20250430174354_region_code ON "AmazonDAX_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonDAX_20250430174354_pricing_region ON "AmazonDAX_ingestion" ("pricing_region");
