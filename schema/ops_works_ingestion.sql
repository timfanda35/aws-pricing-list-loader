CREATE TABLE ops_works_ingestion (
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
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "server_location" TEXT,
    "service_name" TEXT
);
CREATE INDEX ops_works_20221216122723_sku ON ops_works_ingestion (sku);
CREATE INDEX ops_works_20221216122723_region_code ON ops_works_ingestion (region_code);
