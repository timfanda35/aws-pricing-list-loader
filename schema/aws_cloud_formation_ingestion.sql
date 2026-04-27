CREATE TABLE aws_cloud_formation_ingestion (
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
    "related_to" TEXT,
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "cloud_formation_resource_provider" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX aws_cloud_formation_20250828180213_sku ON aws_cloud_formation_ingestion (sku);
CREATE INDEX aws_cloud_formation_20250828180213_region_code ON aws_cloud_formation_ingestion (region_code);
