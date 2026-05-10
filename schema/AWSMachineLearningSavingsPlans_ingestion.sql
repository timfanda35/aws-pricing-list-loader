CREATE TABLE IF NOT EXISTS "AWSMachineLearningSavingsPlans_ingestion" (
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
CREATE INDEX IF NOT EXISTS AWSMachineLearningSavingsPlans_20260506155308_sku ON "AWSMachineLearningSavingsPlans_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSMachineLearningSavingsPlans_20260506155308_discount_fb8df07b ON "AWSMachineLearningSavingsPlans_ingestion" ("discounted_region_code");
CREATE INDEX IF NOT EXISTS AWSMachineLearningSavingsPlans_20260506155308_pricing_region ON "AWSMachineLearningSavingsPlans_ingestion" ("pricing_region");
