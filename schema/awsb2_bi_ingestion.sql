CREATE TABLE awsb2_bi_ingestion (
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
    "input_format" TEXT,
    "output_format" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "type" TEXT
);
CREATE INDEX awsb2_bi_20260310141045_sku ON awsb2_bi_ingestion (sku);
CREATE INDEX awsb2_bi_20260310141045_region_code ON awsb2_bi_ingestion (region_code);
