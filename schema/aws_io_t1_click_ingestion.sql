CREATE TABLE aws_io_t1_click_ingestion (
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
    "device" TEXT,
    "device_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX aws_io_t1_click_20220204221101_sku ON aws_io_t1_click_ingestion (sku);
CREATE INDEX aws_io_t1_click_20220204221101_region_code ON aws_io_t1_click_ingestion (region_code);
