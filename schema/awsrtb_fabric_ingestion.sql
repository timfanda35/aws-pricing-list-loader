CREATE TABLE awsrtb_fabric_ingestion (
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
    "related_to" TEXT,
    "product_family" TEXT,
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "transaction_network" TEXT
);
CREATE INDEX awsrtb_fabric_20251128184615_sku ON awsrtb_fabric_ingestion (sku);
CREATE INDEX awsrtb_fabric_20251128184615_region_code ON awsrtb_fabric_ingestion (region_code);
