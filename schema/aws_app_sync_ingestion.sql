CREATE TABLE aws_app_sync_ingestion (
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
    "cache_memory_size" TEXT,
    "event_api_operation" TEXT,
    "graph_ql_operation" TEXT,
    "protocol" TEXT,
    "real_time_operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX aws_app_sync_20250623155322_sku ON aws_app_sync_ingestion (sku);
CREATE INDEX aws_app_sync_20250623155322_region_code ON aws_app_sync_ingestion (region_code);
