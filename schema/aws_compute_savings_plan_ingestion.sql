CREATE TABLE aws_compute_savings_plan_ingestion (
    "sku" TEXT,
    "rate_code" TEXT PRIMARY KEY,
    "unit" TEXT,
    "effective_date" DATE,
    "discounted_rate" DECIMAL(20,10),
    "currency" TEXT,
    "discounted_sku" TEXT,
    "discounted_service_code" TEXT,
    "discounted_usage_type" TEXT,
    "discounted_operation" TEXT,
    "purchase_option" TEXT,
    "lease_contract_length" INTEGER,
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
    "discounted_instance_type" TEXT
);
CREATE INDEX aws_compute_savings_plan_20260427071339_sku ON aws_compute_savings_plan_ingestion (sku);
CREATE INDEX aws_compute_savings_plan_20260427071339_discounted_region_code ON aws_compute_savings_plan_ingestion (discounted_region_code);
