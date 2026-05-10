CREATE TABLE IF NOT EXISTS "AWSComputeSavingsPlan_ingestion" (
    "sku" TEXT,
    "rate_code" TEXT,
    "unit" TEXT,
    "effective_date" DATE,
    "discounted_rate" DECIMAL(20,10),
    "currency" TEXT,
    "discounted_sku" TEXT,
    "discounted_service_code" TEXT,
    "discounted_usage_type" TEXT,
    "discounted_operation" TEXT,
    "purchase_option" TEXT,
    "lease_contract_length" TEXT,
    "lease_contract_length_unit" TEXT,
    "service_code" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "description" TEXT,
    "instance_family" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "granularity" TEXT,
    "product_family" TEXT,
    "discounted_region_code" TEXT,
    "discounted_instance_type" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AWSComputeSavingsPlan_20260508023241_sku ON "AWSComputeSavingsPlan_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSComputeSavingsPlan_20260508023241_discounted_region_code ON "AWSComputeSavingsPlan_ingestion" ("discounted_region_code");
CREATE INDEX IF NOT EXISTS AWSComputeSavingsPlan_20260508023241_pricing_region ON "AWSComputeSavingsPlan_ingestion" ("pricing_region");
