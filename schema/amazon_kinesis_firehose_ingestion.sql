CREATE TABLE amazon_kinesis_firehose_ingestion (
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
    "group" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "source_type" TEXT,
    "ticket_type" TEXT
);
CREATE INDEX amazon_kinesis_firehose_20251218180451_sku ON amazon_kinesis_firehose_ingestion (sku);
CREATE INDEX amazon_kinesis_firehose_20251218180451_region_code ON amazon_kinesis_firehose_ingestion (region_code);
