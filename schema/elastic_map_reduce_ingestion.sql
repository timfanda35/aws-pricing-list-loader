CREATE TABLE elastic_map_reduce_ingestion (
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
    "instance_type" TEXT,
    "instance_family" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "compute" TEXT,
    "compute_provider" TEXT,
    "meter_unit" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "software_type" TEXT
);
CREATE INDEX elastic_map_reduce_20260427042746_sku ON elastic_map_reduce_ingestion (sku);
CREATE INDEX elastic_map_reduce_20260427042746_region_code ON elastic_map_reduce_ingestion (region_code);
