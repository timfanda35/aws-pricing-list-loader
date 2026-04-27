CREATE TABLE datapipeline_ingestion (
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
    "group" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "execution_frequency" TEXT,
    "execution_location" TEXT,
    "frequency_mode" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX datapipeline_20230110165411_sku ON datapipeline_ingestion (sku);
CREATE INDEX datapipeline_20230110165411_region_code ON datapipeline_ingestion (region_code);
