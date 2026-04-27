CREATE TABLE io_t_twin_maker_ingestion (
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
    "group" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "tiers" TEXT
);
CREATE INDEX io_t_twin_maker_20231018161701_sku ON io_t_twin_maker_ingestion (sku);
CREATE INDEX io_t_twin_maker_20231018161701_region_code ON io_t_twin_maker_ingestion (region_code);
