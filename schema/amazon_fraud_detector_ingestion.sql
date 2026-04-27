CREATE TABLE amazon_fraud_detector_ingestion (
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
    "usage_type" TEXT,
    "operation" TEXT,
    "prediction_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_fraud_detector_20220706230021_sku ON amazon_fraud_detector_ingestion (sku);
CREATE INDEX amazon_fraud_detector_20220706230021_region_code ON amazon_fraud_detector_ingestion (region_code);
