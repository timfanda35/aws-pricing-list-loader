CREATE TABLE aws_elemental_media_store_ingestion (
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
    "availability" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "durability" TEXT,
    "ingest_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "storage_class" TEXT
);
CREATE INDEX aws_elemental_media_store_20220204184110_sku ON aws_elemental_media_store_ingestion (sku);
CREATE INDEX aws_elemental_media_store_20220204184110_region_code ON aws_elemental_media_store_ingestion (region_code);
