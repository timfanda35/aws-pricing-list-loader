CREATE TABLE app_flow_ingestion (
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
    "flow" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX app_flow_20220304194505_sku ON app_flow_ingestion (sku);
CREATE INDEX app_flow_20220304194505_region_code ON app_flow_ingestion (region_code);
