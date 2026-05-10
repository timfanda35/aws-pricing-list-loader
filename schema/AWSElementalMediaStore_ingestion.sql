CREATE TABLE IF NOT EXISTS "AWSElementalMediaStore_ingestion" (
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
    "description" TEXT,
    "location" TEXT,
    "location_type" TEXT,
    "availability" TEXT,
    "usage_type" TEXT,
    "operation" TEXT,
    "durability" TEXT,
    "ingest_type" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "storage_class" TEXT
);
CREATE INDEX IF NOT EXISTS AWSElementalMediaStore_20220204184110_sku ON "AWSElementalMediaStore_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSElementalMediaStore_20220204184110_region_code ON "AWSElementalMediaStore_ingestion" ("region_code");
