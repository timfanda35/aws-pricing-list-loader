CREATE TABLE amazon_chime_voice_connector_ingestion (
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
    "call_type" TEXT,
    "from_country" TEXT,
    "messagetype" TEXT,
    "number_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "to_country" TEXT
);
CREATE INDEX amazon_chime_voice_connector_20260408194915_sku ON amazon_chime_voice_connector_ingestion (sku);
CREATE INDEX amazon_chime_voice_connector_20260408194915_region_code ON amazon_chime_voice_connector_ingestion (region_code);
