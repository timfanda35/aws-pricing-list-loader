CREATE TABLE aws_device_farm_ingestion (
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
    "service_name" TEXT
);
CREATE INDEX aws_device_farm_20250113181102_sku ON aws_device_farm_ingestion (sku);
CREATE INDEX aws_device_farm_20250113181102_region_code ON aws_device_farm_ingestion (region_code);
