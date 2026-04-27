CREATE TABLE awsm2_ingestion (
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
    "instance_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "free_tier" TEXT,
    "product_name" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX awsm2_20260311145747_sku ON awsm2_ingestion (sku);
CREATE INDEX awsm2_20260311145747_region_code ON awsm2_ingestion (region_code);
