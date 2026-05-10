CREATE TABLE IF NOT EXISTS "AWSDeviceFarm_ingestion" (
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
    "device_os" TEXT,
    "execution_mode" TEXT,
    "meter_mode" TEXT,
    "os" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AWSDeviceFarm_20250113181102_sku ON "AWSDeviceFarm_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSDeviceFarm_20250113181102_region_code ON "AWSDeviceFarm_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AWSDeviceFarm_20250113181102_pricing_region ON "AWSDeviceFarm_ingestion" ("pricing_region");
