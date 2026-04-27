CREATE TABLE amazon_personalize_ingestion (
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
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "tier" TEXT
);
CREATE INDEX amazon_personalize_20240507210355_sku ON amazon_personalize_ingestion (sku);
CREATE INDEX amazon_personalize_20240507210355_region_code ON amazon_personalize_ingestion (region_code);
