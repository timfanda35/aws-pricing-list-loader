CREATE TABLE amazon_polly_ingestion (
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
    "engine" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_polly_20260323164833_sku ON amazon_polly_ingestion (sku);
CREATE INDEX amazon_polly_20260323164833_region_code ON amazon_polly_ingestion (region_code);
