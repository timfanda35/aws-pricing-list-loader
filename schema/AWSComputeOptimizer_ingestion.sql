CREATE TABLE IF NOT EXISTS "AWSComputeOptimizer_ingestion" (
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
    "enhanced_infrastructure_metrics" TEXT,
    "pricing_unit" TEXT,
    "region_code" TEXT,
    "resource_type" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AWSComputeOptimizer_20240826152358_sku ON "AWSComputeOptimizer_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSComputeOptimizer_20240826152358_region_code ON "AWSComputeOptimizer_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AWSComputeOptimizer_20240826152358_pricing_region ON "AWSComputeOptimizer_ingestion" ("pricing_region");
