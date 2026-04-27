CREATE TABLE aws_compute_optimizer_ingestion (
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
    "enhanced_infrastructure_metrics" TEXT,
    "pricing_unit" TEXT,
    "region_code" TEXT,
    "resource_type" TEXT,
    "service_name" TEXT
);
CREATE INDEX aws_compute_optimizer_20240826152358_sku ON aws_compute_optimizer_ingestion (sku);
CREATE INDEX aws_compute_optimizer_20240826152358_region_code ON aws_compute_optimizer_ingestion (region_code);
