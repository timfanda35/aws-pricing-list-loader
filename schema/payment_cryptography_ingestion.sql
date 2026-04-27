CREATE TABLE payment_cryptography_ingestion (
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
    "api_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX payment_cryptography_20260414230430_sku ON payment_cryptography_ingestion (sku);
CREATE INDEX payment_cryptography_20260414230430_region_code ON payment_cryptography_ingestion (region_code);
