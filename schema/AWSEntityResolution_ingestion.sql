CREATE TABLE IF NOT EXISTS "AWSEntityResolution_ingestion" (
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
    "operation_type" TEXT,
    "region_code" TEXT,
    "resolution_type" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AWSEntityResolution_20250513205946_sku ON "AWSEntityResolution_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSEntityResolution_20250513205946_region_code ON "AWSEntityResolution_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AWSEntityResolution_20250513205946_pricing_region ON "AWSEntityResolution_ingestion" ("pricing_region");
