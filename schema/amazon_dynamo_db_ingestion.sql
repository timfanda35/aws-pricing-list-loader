CREATE TABLE amazon_dynamo_db_ingestion (
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
    "lease_contract_length" INTEGER,
    "purchase_option" TEXT,
    "offering_class" TEXT,
    "product_family" TEXT,
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "volume_type" TEXT,
    "group" TEXT,
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_dynamo_db_20250828153819_sku ON amazon_dynamo_db_ingestion (sku);
CREATE INDEX amazon_dynamo_db_20250828153819_region_code ON amazon_dynamo_db_ingestion (region_code);
