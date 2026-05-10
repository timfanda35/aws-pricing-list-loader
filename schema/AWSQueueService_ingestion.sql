CREATE TABLE IF NOT EXISTS "AWSQueueService_ingestion" (
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
    "group" TEXT,
    "group_description" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "message_delivery_frequency" TEXT,
    "message_delivery_order" TEXT,
    "queue_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT
);
CREATE INDEX IF NOT EXISTS AWSQueueService_20250828200713_sku ON "AWSQueueService_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSQueueService_20250828200713_region_code ON "AWSQueueService_ingestion" ("region_code");
