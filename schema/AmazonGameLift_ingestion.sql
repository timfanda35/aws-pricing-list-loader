CREATE TABLE IF NOT EXISTS "AmazonGameLift_ingestion" (
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
    "v_cpu" TEXT,
    "operating_system" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "ecu" TEXT,
    "instance_storage_gb" TEXT,
    "is_spot_instance" TEXT,
    "memory_gi_b" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonGameLift_20260326200859_sku ON "AmazonGameLift_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonGameLift_20260326200859_region_code ON "AmazonGameLift_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonGameLift_20260326200859_pricing_region ON "AmazonGameLift_ingestion" ("pricing_region");
