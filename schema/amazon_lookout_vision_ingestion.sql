CREATE TABLE amazon_lookout_vision_ingestion (
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
    "lookout_vision_image" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_lookout_vision_20230309234949_sku ON amazon_lookout_vision_ingestion (sku);
CREATE INDEX amazon_lookout_vision_20230309234949_region_code ON amazon_lookout_vision_ingestion (region_code);
