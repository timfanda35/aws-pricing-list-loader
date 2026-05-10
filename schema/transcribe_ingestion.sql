CREATE TABLE IF NOT EXISTS "transcribe_ingestion" (
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
    "region_code" TEXT,
    "service_name" TEXT,
    "supported_modes" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS transcribe_20260331003333_sku ON "transcribe_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS transcribe_20260331003333_region_code ON "transcribe_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS transcribe_20260331003333_pricing_region ON "transcribe_ingestion" ("pricing_region");
