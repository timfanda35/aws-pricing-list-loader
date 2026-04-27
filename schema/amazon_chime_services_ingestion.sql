CREATE TABLE amazon_chime_services_ingestion (
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
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "license_type" TEXT,
    "primary_place_of_use" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "transaction_type" TEXT
);
CREATE INDEX amazon_chime_services_20241219235601_sku ON amazon_chime_services_ingestion (sku);
CREATE INDEX amazon_chime_services_20241219235601_region_code ON amazon_chime_services_ingestion (region_code);
