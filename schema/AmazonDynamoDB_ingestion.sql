CREATE TABLE IF NOT EXISTS "AmazonDynamoDB_ingestion" (
    "sku" TEXT,
    "offer_term_code" TEXT,
    "rate_code" TEXT,
    "term_type" TEXT,
    "price_description" TEXT,
    "effective_date" DATE,
    "starting_range" TEXT,
    "ending_range" TEXT,
    "unit" TEXT,
    "price_per_unit" DECIMAL(20,10),
    "currency" TEXT,
    "lease_contract_length" TEXT,
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
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonDynamoDB_20250828153819_sku ON "AmazonDynamoDB_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonDynamoDB_20250828153819_region_code ON "AmazonDynamoDB_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonDynamoDB_20250828153819_pricing_region ON "AmazonDynamoDB_ingestion" ("pricing_region");
