CREATE TABLE IF NOT EXISTS "AmazonBedrockFoundationModels_ingestion" (
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
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AmazonBedrockFoundationModels_20260501202025_sku ON "AmazonBedrockFoundationModels_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AmazonBedrockFoundationModels_20260501202025_region_code ON "AmazonBedrockFoundationModels_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AmazonBedrockFoundationModels_20260501202025_pricing_region ON "AmazonBedrockFoundationModels_ingestion" ("pricing_region");
