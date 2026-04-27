CREATE TABLE awsmdc_ingestion (
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
    "configuration" TEXT,
    "contract_length" TEXT,
    "design_version" TEXT,
    "region" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX awsmdc_20260415142055_sku ON awsmdc_ingestion (sku);
CREATE INDEX awsmdc_20260415142055_region_code ON awsmdc_ingestion (region_code);
