CREATE TABLE auditmanager_ingestion (
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
    "region_code" TEXT,
    "resource_assessment" TEXT,
    "service_name" TEXT
);
CREATE INDEX auditmanager_20230209151230_sku ON auditmanager_ingestion (sku);
CREATE INDEX auditmanager_20230209151230_region_code ON auditmanager_ingestion (region_code);
