CREATE TABLE IF NOT EXISTS "AWSB2Bi_ingestion" (
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
    "product_family" TEXT,
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "input_format" TEXT,
    "output_format" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "type" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AWSB2Bi_20260310141045_sku ON "AWSB2Bi_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSB2Bi_20260310141045_region_code ON "AWSB2Bi_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AWSB2Bi_20260310141045_pricing_region ON "AWSB2Bi_ingestion" ("pricing_region");
