CREATE TABLE amazon_efs_ingestion (
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
    "storage_class" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "access_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "throughput_class" TEXT
);
CREATE INDEX amazon_efs_20250925214139_sku ON amazon_efs_ingestion (sku);
CREATE INDEX amazon_efs_20250925214139_region_code ON amazon_efs_ingestion (region_code);
