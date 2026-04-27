CREATE TABLE cloud_hsm_ingestion (
    "sku" TEXT,
    "offer_term_code" TEXT,
    "rate_code" TEXT PRIMARY KEY,
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
    "upfront_commitment" TEXT
);
CREATE INDEX cloud_hsm_20260416190528_sku ON cloud_hsm_ingestion (sku);
CREATE INDEX cloud_hsm_20260416190528_region_code ON cloud_hsm_ingestion (region_code);
