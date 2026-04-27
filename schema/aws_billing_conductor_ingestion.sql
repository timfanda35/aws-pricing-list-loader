CREATE TABLE aws_billing_conductor_ingestion (
    "sku" TEXT,
    "offer_term_code" TEXT,
    "rate_code" TEXT PRIMARY KEY,
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
    "transfer_billing_billing_groups" TEXT
);
CREATE INDEX aws_billing_conductor_20251119205537_sku ON aws_billing_conductor_ingestion (sku);
CREATE INDEX aws_billing_conductor_20251119205537_region_code ON aws_billing_conductor_ingestion (region_code);
