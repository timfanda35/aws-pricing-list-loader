CREATE TABLE amazon_api_gateway_ingestion (
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
    "description" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "cache_memory_size_gb" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_api_gateway_20251120010652_sku ON amazon_api_gateway_ingestion (sku);
CREATE INDEX amazon_api_gateway_20251120010652_region_code ON amazon_api_gateway_ingestion (region_code);
