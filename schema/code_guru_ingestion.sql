CREATE TABLE code_guru_ingestion (
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
    "base_product_reference_code" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX code_guru_20230110163615_sku ON code_guru_ingestion (sku);
CREATE INDEX code_guru_20230110163615_region_code ON code_guru_ingestion (region_code);
