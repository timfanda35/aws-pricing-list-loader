CREATE TABLE aws_telco_network_builder_ingestion (
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
    "usage_type" TEXT,
    "operation" TEXT,
    "mnfi" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "tnbap_icalls" TEXT
);
CREATE INDEX aws_telco_network_builder_20250130200015_sku ON aws_telco_network_builder_ingestion (sku);
CREATE INDEX aws_telco_network_builder_20250130200015_region_code ON aws_telco_network_builder_ingestion (region_code);
