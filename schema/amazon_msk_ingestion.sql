CREATE TABLE amazon_msk_ingestion (
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
    "v_cpu" TEXT,
    "group" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "compute_family" TEXT,
    "memory_gi_b" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "storage_family" TEXT
);
CREATE INDEX amazon_msk_20260422040553_sku ON amazon_msk_ingestion (sku);
CREATE INDEX amazon_msk_20260422040553_region_code ON amazon_msk_ingestion (region_code);
