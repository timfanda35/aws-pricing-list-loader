CREATE TABLE aws_events_ingestion (
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
    "event_type" TEXT,
    "invocation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "time_window" TEXT
);
CREATE INDEX aws_events_20260203185746_sku ON aws_events_ingestion (sku);
CREATE INDEX aws_events_20260203185746_region_code ON aws_events_ingestion (region_code);
