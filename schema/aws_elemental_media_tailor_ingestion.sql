CREATE TABLE aws_elemental_media_tailor_ingestion (
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
    "operation_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "tier" TEXT
);
CREATE INDEX aws_elemental_media_tailor_20260317161050_sku ON aws_elemental_media_tailor_ingestion (sku);
CREATE INDEX aws_elemental_media_tailor_20260317161050_region_code ON aws_elemental_media_tailor_ingestion (region_code);
