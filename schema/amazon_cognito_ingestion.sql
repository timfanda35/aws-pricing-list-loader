CREATE TABLE amazon_cognito_ingestion (
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
    "related_to" TEXT,
    "product_family" TEXT,
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "api_category" TEXT,
    "duration" TEXT,
    "m2m_category" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_cognito_20260424223102_sku ON amazon_cognito_ingestion (sku);
CREATE INDEX amazon_cognito_20260424223102_region_code ON amazon_cognito_ingestion (region_code);
