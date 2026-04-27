CREATE TABLE amazon_forecast_ingestion (
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
    "service_code" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "group_details" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX amazon_forecast_20230202173358_sku ON amazon_forecast_ingestion (sku);
CREATE INDEX amazon_forecast_20230202173358_region_code ON amazon_forecast_ingestion (region_code);
