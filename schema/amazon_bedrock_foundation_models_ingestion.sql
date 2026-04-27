CREATE TABLE amazon_bedrock_foundation_models_ingestion (
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
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_bedrock_foundation_models_20260416143347_sku ON amazon_bedrock_foundation_models_ingestion (sku);
CREATE INDEX amazon_bedrock_foundation_models_20260416143347_region_code ON amazon_bedrock_foundation_models_ingestion (region_code);
