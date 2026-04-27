CREATE TABLE aws_elemental_inference_ingestion (
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
    "feature_mode" TEXT,
    "features_used" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX aws_elemental_inference_20260224163020_sku ON aws_elemental_inference_ingestion (sku);
CREATE INDEX aws_elemental_inference_20260224163020_region_code ON aws_elemental_inference_ingestion (region_code);
