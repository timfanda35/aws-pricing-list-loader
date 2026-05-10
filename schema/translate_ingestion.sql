CREATE TABLE IF NOT EXISTS "translate_ingestion" (
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
    "file_type" TEXT,
    "input_mode" TEXT,
    "output_mode" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS translate_20230720005517_sku ON "translate_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS translate_20230720005517_region_code ON "translate_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS translate_20230720005517_pricing_region ON "translate_ingestion" ("pricing_region");
