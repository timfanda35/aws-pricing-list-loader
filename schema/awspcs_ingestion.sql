CREATE TABLE awspcs_ingestion (
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
    "usage_type" TEXT,
    "operation" TEXT,
    "controller_size" TEXT,
    "controller_state" TEXT,
    "db_state" TEXT,
    "node_type" TEXT,
    "region_code" TEXT,
    "scheduler_type" TEXT,
    "service_name" TEXT
);
CREATE INDEX awspcs_20260423135432_sku ON awspcs_ingestion (sku);
CREATE INDEX awspcs_20260423135432_region_code ON awspcs_ingestion (region_code);
