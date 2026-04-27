CREATE TABLE aws_elastic_disaster_recovery_ingestion (
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
    "region_code" TEXT,
    "replication_type" TEXT,
    "service_name" TEXT
);
CREATE INDEX aws_elastic_disaster_recovery_20241107084624_sku ON aws_elastic_disaster_recovery_ingestion (sku);
CREATE INDEX aws_elastic_disaster_recovery_20241107084624_region_code ON aws_elastic_disaster_recovery_ingestion (region_code);
