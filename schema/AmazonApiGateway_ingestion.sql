CREATE TABLE IF NOT EXISTS "AmazonApiGateway_ingestion" (
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
    "description" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "cache_memory_size_gb" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonApiGateway_20251120010652_sku ON "AmazonApiGateway_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonApiGateway_20251120010652_region_code ON "AmazonApiGateway_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonApiGateway_20251120010652_pricing_region ON "AmazonApiGateway_ingestion" ("pricing_region");
