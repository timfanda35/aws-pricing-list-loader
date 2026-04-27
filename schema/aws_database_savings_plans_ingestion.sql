CREATE TABLE aws_database_savings_plans_ingestion (
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
CREATE INDEX aws_database_savings_plans_20260422194203_sku ON aws_database_savings_plans_ingestion (sku);
CREATE INDEX aws_database_savings_plans_20260422194203_discounted_r_012bfc8c ON aws_database_savings_plans_ingestion (discounted_region_code);
