CREATE TABLE IF NOT EXISTS "CustomerProfiles_ingestion" (
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
    "locke_profiles" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS CustomerProfiles_20241217135817_sku ON "CustomerProfiles_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS CustomerProfiles_20241217135817_region_code ON "CustomerProfiles_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS CustomerProfiles_20241217135817_pricing_region ON "CustomerProfiles_ingestion" ("pricing_region");
