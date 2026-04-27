CREATE TABLE amazon_pinpoint_ingestion (
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
    "iso" TEXT,
    "message_count_fee" TEXT,
    "message_type" TEXT,
    "origination_id" TEXT,
    "region_code" TEXT,
    "route_type" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_pinpoint_20260328181449_sku ON amazon_pinpoint_ingestion (sku);
CREATE INDEX amazon_pinpoint_20260328181449_region_code ON amazon_pinpoint_ingestion (region_code);
