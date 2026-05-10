CREATE TABLE IF NOT EXISTS "SimSpaceWeaver_ingestion" (
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
    "app_slots" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "sim_instance_family" TEXT,
    "sim_instance_type" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS SimSpaceWeaver_20230607150705_sku ON "SimSpaceWeaver_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS SimSpaceWeaver_20230607150705_region_code ON "SimSpaceWeaver_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS SimSpaceWeaver_20230607150705_pricing_region ON "SimSpaceWeaver_ingestion" ("pricing_region");
