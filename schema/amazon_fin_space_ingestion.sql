CREATE TABLE amazon_fin_space_ingestion (
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
    "v_cpu" TEXT,
    "memory" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "details" TEXT,
    "node" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "storage_type" TEXT
);
CREATE INDEX amazon_fin_space_20240829172011_sku ON amazon_fin_space_ingestion (sku);
CREATE INDEX amazon_fin_space_20240829172011_region_code ON amazon_fin_space_ingestion (region_code);
