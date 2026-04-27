CREATE TABLE awsfis_ingestion (
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
    "action" TEXT,
    "region_code" TEXT,
    "report_type" TEXT,
    "service_name" TEXT
);
CREATE INDEX awsfis_20260121102916_sku ON awsfis_ingestion (sku);
CREATE INDEX awsfis_20260121102916_region_code ON awsfis_ingestion (region_code);
