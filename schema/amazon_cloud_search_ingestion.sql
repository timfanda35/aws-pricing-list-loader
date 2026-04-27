CREATE TABLE amazon_cloud_search_ingestion (
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
    "instance_type" TEXT,
    "group" TEXT,
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "cloud_search_version" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_cloud_search_20221122170456_sku ON amazon_cloud_search_ingestion (sku);
CREATE INDEX amazon_cloud_search_20221122170456_region_code ON amazon_cloud_search_ingestion (region_code);
