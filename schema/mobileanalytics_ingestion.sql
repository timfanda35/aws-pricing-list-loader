CREATE TABLE mobileanalytics_ingestion (
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
    "included_events" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX mobileanalytics_20230127115017_sku ON mobileanalytics_ingestion (sku);
CREATE INDEX mobileanalytics_20230127115017_region_code ON mobileanalytics_ingestion (region_code);
