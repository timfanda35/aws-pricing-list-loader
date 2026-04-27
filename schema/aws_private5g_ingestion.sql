CREATE TABLE aws_private5g_ingestion (
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
    "access_point_type" TEXT,
    "capability" TEXT,
    "commitment_days" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX aws_private5g_20230628174401_sku ON aws_private5g_ingestion (sku);
CREATE INDEX aws_private5g_20230628174401_region_code ON aws_private5g_ingestion (region_code);
