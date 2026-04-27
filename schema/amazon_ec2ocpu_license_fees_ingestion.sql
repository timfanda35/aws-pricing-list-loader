CREATE TABLE amazon_ec2ocpu_license_fees_ingestion (
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
    "operating_system" TEXT,
    "license_model" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "instance_family_category" TEXT,
    "pre_installed_s_w" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_ec2ocpu_license_fees_20260424225604_sku ON amazon_ec2ocpu_license_fees_ingestion (sku);
CREATE INDEX amazon_ec2ocpu_license_fees_20260424225604_region_code ON amazon_ec2ocpu_license_fees_ingestion (region_code);
