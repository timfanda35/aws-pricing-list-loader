CREATE TABLE acm_ingestion (
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
    "certificate_domain_type" TEXT,
    "certificate_export_type" TEXT,
    "certificate_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX acm_20260218141316_sku ON acm_ingestion (sku);
CREATE INDEX acm_20260218141316_region_code ON acm_ingestion (region_code);
