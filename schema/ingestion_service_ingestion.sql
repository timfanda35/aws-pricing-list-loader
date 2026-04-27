CREATE TABLE ingestion_service_ingestion (
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
    "data_action" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX ingestion_service_20230110163633_sku ON ingestion_service_ingestion (sku);
CREATE INDEX ingestion_service_20230110163633_region_code ON ingestion_service_ingestion (region_code);
