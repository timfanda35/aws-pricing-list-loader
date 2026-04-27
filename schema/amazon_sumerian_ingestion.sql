CREATE TABLE amazon_sumerian_ingestion (
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
    "event_type" TEXT,
    "offer" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_sumerian_20230110161523_sku ON amazon_sumerian_ingestion (sku);
CREATE INDEX amazon_sumerian_20230110161523_region_code ON amazon_sumerian_ingestion (region_code);
