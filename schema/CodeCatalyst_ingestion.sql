CREATE TABLE IF NOT EXISTS "CodeCatalyst_ingestion" (
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
    "usage_type" TEXT,
    "operation" TEXT,
    "charge_type" TEXT,
    "instance_size" TEXT,
    "os_type" TEXT,
    "package_type" TEXT,
    "provisioning_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "storage_type" TEXT,
    "tier" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS CodeCatalyst_20231122231921_sku ON "CodeCatalyst_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS CodeCatalyst_20231122231921_region_code ON "CodeCatalyst_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS CodeCatalyst_20231122231921_pricing_region ON "CodeCatalyst_ingestion" ("pricing_region");
