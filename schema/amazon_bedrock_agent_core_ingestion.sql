CREATE TABLE amazon_bedrock_agent_core_ingestion (
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
    "resource" TEXT,
    "service_name" TEXT,
    "strategy" TEXT,
    "tier" TEXT,
    "type" TEXT
);
CREATE INDEX amazon_bedrock_agent_core_20260423214753_sku ON amazon_bedrock_agent_core_ingestion (sku);
CREATE INDEX amazon_bedrock_agent_core_20260423214753_region_code ON amazon_bedrock_agent_core_ingestion (region_code);
