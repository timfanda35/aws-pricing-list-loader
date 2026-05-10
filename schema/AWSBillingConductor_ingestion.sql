CREATE TABLE IF NOT EXISTS "AWSBillingConductor_ingestion" (
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
    "group" TEXT,
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "accounts" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "transfer_billing_billing_groups" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AWSBillingConductor_20251119205537_sku ON "AWSBillingConductor_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSBillingConductor_20251119205537_region_code ON "AWSBillingConductor_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AWSBillingConductor_20251119205537_pricing_region ON "AWSBillingConductor_ingestion" ("pricing_region");
