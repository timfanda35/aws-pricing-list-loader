CREATE TABLE customer_profiles_ingestion (
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
    "locke_profiles" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX customer_profiles_20241217135817_sku ON customer_profiles_ingestion (sku);
CREATE INDEX customer_profiles_20241217135817_region_code ON customer_profiles_ingestion (region_code);
