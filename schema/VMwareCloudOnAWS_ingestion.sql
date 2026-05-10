CREATE TABLE IF NOT EXISTS "VMwareCloudOnAWS_ingestion" (
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
    "description" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "brio_product_id" TEXT,
    "charge_id" TEXT,
    "is_commit_cpsku" TEXT,
    "product_group_id" TEXT,
    "product_sub_group" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "vm_ware_product_id" TEXT,
    "v_mware_region" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS VMwareCloudOnAWS_20250113111133_sku ON "VMwareCloudOnAWS_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS VMwareCloudOnAWS_20250113111133_region_code ON "VMwareCloudOnAWS_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS VMwareCloudOnAWS_20250113111133_pricing_region ON "VMwareCloudOnAWS_ingestion" ("pricing_region");
