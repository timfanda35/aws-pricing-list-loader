CREATE TABLE IF NOT EXISTS "OracleDbAtAWS_ingestion" (
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
    "region_code" TEXT,
    "service_name" TEXT,
    "workload_type" TEXT,
    "zero_etl_feature" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS OracleDbAtAWS_20250701231635_sku ON "OracleDbAtAWS_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS OracleDbAtAWS_20250701231635_region_code ON "OracleDbAtAWS_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS OracleDbAtAWS_20250701231635_pricing_region ON "OracleDbAtAWS_ingestion" ("pricing_region");
