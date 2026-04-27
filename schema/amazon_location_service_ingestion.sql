CREATE TABLE amazon_location_service_ingestion (
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
    "pricing_plan" TEXT,
    "provider" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "sub_service" TEXT,
    "type" TEXT
);
CREATE INDEX amazon_location_service_20260421211408_sku ON amazon_location_service_ingestion (sku);
CREATE INDEX amazon_location_service_20260421211408_region_code ON amazon_location_service_ingestion (region_code);
