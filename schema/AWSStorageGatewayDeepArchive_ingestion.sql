CREATE TABLE IF NOT EXISTS "AWSStorageGatewayDeepArchive_ingestion" (
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
    "storage_class" TEXT,
    "fee_code" TEXT,
    "fee_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "maximum_capacity" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "storage_description" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AWSStorageGatewayDeepArchive_20251009170919_sku ON "AWSStorageGatewayDeepArchive_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSStorageGatewayDeepArchive_20251009170919_region_code ON "AWSStorageGatewayDeepArchive_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AWSStorageGatewayDeepArchive_20251009170919_pricing_region ON "AWSStorageGatewayDeepArchive_ingestion" ("pricing_region");
