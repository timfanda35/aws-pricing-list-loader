CREATE TABLE aws_amplify_ingestion (
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
    "storage" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "data_transfer_out" TEXT,
    "instance_type" TEXT,
    "region_code" TEXT,
    "request_count" TEXT,
    "request_duration" TEXT,
    "service_name" TEXT
);
CREATE INDEX aws_amplify_20250620171023_sku ON aws_amplify_ingestion (sku);
CREATE INDEX aws_amplify_20250620171023_region_code ON aws_amplify_ingestion (region_code);
