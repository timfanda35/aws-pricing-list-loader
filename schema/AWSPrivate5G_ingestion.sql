CREATE TABLE IF NOT EXISTS "AWSPrivate5G_ingestion" (
    "sku" TEXT,
    "offer_term_code" TEXT,
    "rate_code" TEXT,
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
    "access_point_type" TEXT,
    "capability" TEXT,
    "commitment_days" TEXT,
    "region_code" TEXT,
    "service_name" TEXT,
    "pricing_region" TEXT NOT NULL,
    PRIMARY KEY (rate_code, pricing_region)
);
CREATE INDEX IF NOT EXISTS AWSPrivate5G_20230628174401_sku ON "AWSPrivate5G_ingestion" ("sku");
CREATE INDEX IF NOT EXISTS AWSPrivate5G_20230628174401_region_code ON "AWSPrivate5G_ingestion" ("region_code");
CREATE INDEX IF NOT EXISTS AWSPrivate5G_20230628174401_pricing_region ON "AWSPrivate5G_ingestion" ("pricing_region");
