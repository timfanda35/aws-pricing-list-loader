import hashlib

import pytest

from app.services.schema_builder import (
    _column_definition,
    _index_name,
    build_schema_sql,
)


class TestColumnDefinition:
    def test_unknown_column_defaults_to_text(self):
        assert _column_definition("description") == '    "description" TEXT'

    def test_rate_code_gets_primary_key(self):
        assert _column_definition("rate_code") == '    "rate_code" TEXT PRIMARY KEY'

    def test_price_per_unit_is_decimal(self):
        assert _column_definition("price_per_unit") == '    "price_per_unit" DECIMAL(20,10)'

    def test_effective_date_is_date(self):
        assert _column_definition("effective_date") == '    "effective_date" DATE'

    def test_lease_contract_length_is_integer(self):
        assert _column_definition("lease_contract_length") == '    "lease_contract_length" INTEGER'

    def test_discounted_rate_is_decimal(self):
        assert _column_definition("discounted_rate") == '    "discounted_rate" DECIMAL(20,10)'


class TestIndexName:
    def test_short_name_returned_unchanged(self):
        name = _index_name("amazon_bedrock_ingestion", "20260101", "sku")
        assert name == "amazon_bedrock_20260101_sku"
        assert len(name) <= 63

    def test_long_name_truncated_to_63_chars(self):
        # This combination exceeds 63 chars
        table = "aws_some_very_long_service_name_ingestion"
        version = "20260116160258"
        col = "discounted_region_code"
        name = _index_name(table, version, col)
        assert len(name) == 63

    def test_long_name_has_md5_suffix(self):
        table = "aws_some_very_long_service_name_ingestion"
        version = "20260116160258"
        col = "discounted_region_code"
        full = "aws_some_very_long_service_name_20260116160258_discounted_region_code"
        expected_suffix = "_" + hashlib.md5(full.encode()).hexdigest()[:8]
        name = _index_name(table, version, col)
        assert name.endswith(expected_suffix)


class TestBuildSchemaSql:
    def test_creates_table_statement(self):
        sql = build_schema_sql("test_ingestion", ["sku", "rate_code"], "20260101")
        assert "CREATE TABLE IF NOT EXISTS test_ingestion" in sql

    def test_includes_all_columns(self):
        sql = build_schema_sql("test_ingestion", ["sku", "rate_code", "description"], "20260101")
        assert '"sku" TEXT' in sql
        assert '"rate_code" TEXT PRIMARY KEY' in sql
        assert '"description" TEXT' in sql

    def test_creates_index_for_sku(self):
        sql = build_schema_sql("test_ingestion", ["sku", "rate_code"], "20260101")
        assert "CREATE INDEX" in sql
        assert "ON test_ingestion (sku)" in sql

    def test_creates_index_for_region_code(self):
        sql = build_schema_sql("test_ingestion", ["rate_code", "region_code"], "20260101")
        assert "ON test_ingestion (region_code)" in sql

    def test_no_index_for_regular_columns(self):
        sql = build_schema_sql("test_ingestion", ["rate_code", "description"], "20260101")
        assert "ON test_ingestion (description)" not in sql

    def test_applies_type_overrides(self):
        sql = build_schema_sql(
            "test_ingestion",
            ["rate_code", "price_per_unit", "effective_date"],
            "20260101",
        )
        assert '"price_per_unit" DECIMAL(20,10)' in sql
        assert '"effective_date" DATE' in sql

    def test_multiple_index_columns(self):
        sql = build_schema_sql(
            "test_ingestion",
            ["rate_code", "sku", "region_code", "discounted_region_code"],
            "20260101",
        )
        assert "ON test_ingestion (sku)" in sql
        assert "ON test_ingestion (region_code)" in sql
        assert "ON test_ingestion (discounted_region_code)" in sql
