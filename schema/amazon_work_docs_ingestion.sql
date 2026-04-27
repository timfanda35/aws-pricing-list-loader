CREATE TABLE amazon_work_docs_ingestion (
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
    "storage" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "free_trial" TEXT,
    "maximum_storage_volume" TEXT,
    "minimum_storage_volume" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_work_docs_20220826032519_sku ON amazon_work_docs_ingestion (sku);
CREATE INDEX amazon_work_docs_20220826032519_region_code ON amazon_work_docs_ingestion (region_code);
