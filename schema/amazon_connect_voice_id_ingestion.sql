CREATE TABLE amazon_connect_voice_id_ingestion (
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
    "region_code" TEXT,
    "service_name" TEXT,
    "type" TEXT
);
CREATE INDEX amazon_connect_voice_id_20230202020116_sku ON amazon_connect_voice_id_ingestion (sku);
CREATE INDEX amazon_connect_voice_id_20230202020116_region_code ON amazon_connect_voice_id_ingestion (region_code);
