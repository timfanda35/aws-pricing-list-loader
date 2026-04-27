CREATE TABLE amazon_ml_ingestion (
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
    "group" TEXT,
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "machine_learning_process" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_ml_20220315082456_sku ON amazon_ml_ingestion (sku);
CREATE INDEX amazon_ml_20220315082456_region_code ON amazon_ml_ingestion (region_code);
