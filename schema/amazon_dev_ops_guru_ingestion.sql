CREATE TABLE amazon_dev_ops_guru_ingestion (
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
    "api_calls" TEXT,
    "region_code" TEXT,
    "resource_price_group" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_dev_ops_guru_20220906172511_sku ON amazon_dev_ops_guru_ingestion (sku);
CREATE INDEX amazon_dev_ops_guru_20220906172511_region_code ON amazon_dev_ops_guru_ingestion (region_code);
