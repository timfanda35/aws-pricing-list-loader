CREATE TABLE amazon_ets_ingestion (
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
    "related_to" TEXT,
    "product_family" TEXT,
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "transcoding_result" TEXT,
    "video_resolution" TEXT
);
CREATE INDEX amazon_ets_20230110161844_sku ON amazon_ets_ingestion (sku);
CREATE INDEX amazon_ets_20230110161844_region_code ON amazon_ets_ingestion (region_code);
