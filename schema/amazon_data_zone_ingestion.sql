CREATE TABLE amazon_data_zone_ingestion (
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
    "job_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "token_type" TEXT
);
CREATE INDEX amazon_data_zone_20241104221431_sku ON amazon_data_zone_ingestion (sku);
CREATE INDEX amazon_data_zone_20241104221431_region_code ON amazon_data_zone_ingestion (region_code);
