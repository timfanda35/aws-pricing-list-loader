CREATE TABLE aws_storage_gateway_ingestion (
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
    "fee_code" TEXT,
    "fee_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "maximum_capacity" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "storage_description" TEXT,
    "version" TEXT
);
CREATE INDEX aws_storage_gateway_20251009170740_sku ON aws_storage_gateway_ingestion (sku);
CREATE INDEX aws_storage_gateway_20251009170740_region_code ON aws_storage_gateway_ingestion (region_code);
