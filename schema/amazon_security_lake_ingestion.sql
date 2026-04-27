CREATE TABLE amazon_security_lake_ingestion (
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
    "log_origin" TEXT,
    "log_source" TEXT,
    "paid" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_security_lake_20240517175829_sku ON amazon_security_lake_ingestion (sku);
CREATE INDEX amazon_security_lake_20240517175829_region_code ON amazon_security_lake_ingestion (region_code);
