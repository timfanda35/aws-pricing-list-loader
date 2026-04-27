CREATE TABLE contact_center_telecomm_ingestion (
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
    "calling_type" TEXT,
    "country" TEXT,
    "line_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX contact_center_telecomm_20260324220442_sku ON contact_center_telecomm_ingestion (sku);
CREATE INDEX contact_center_telecomm_20260324220442_region_code ON contact_center_telecomm_ingestion (region_code);
