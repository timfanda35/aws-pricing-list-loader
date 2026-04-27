CREATE TABLE aws_cost_explorer_ingestion (
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
    "granularity" TEXT,
    "region_code" TEXT,
    "request_type" TEXT,
    "service_name" TEXT
);
CREATE INDEX aws_cost_explorer_20250925213519_sku ON aws_cost_explorer_ingestion (sku);
CREATE INDEX aws_cost_explorer_20250925213519_region_code ON aws_cost_explorer_ingestion (region_code);
