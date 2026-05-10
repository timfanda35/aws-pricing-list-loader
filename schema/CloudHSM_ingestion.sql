CREATE TABLE IF NOT EXISTS "CloudHSM_ingestion" (
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
    "instance_family" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "hsm_generation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "trial_product" TEXT,
    "upfront_commitment" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS CloudHSM_20260416190528_sku ON "CloudHSM_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS CloudHSM_20260416190528_region_code ON "CloudHSM_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS CloudHSM_20260416190528_pricing_region ON "CloudHSM_ingestion" ("pricing_region");
