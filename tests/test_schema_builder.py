import hashlib
from unittest.mock import MagicMock, patch

import pytest

from app.services.schema_builder import (
    _column_definition,
    _index_name,
    build_schema_sql,
    get_csv_column_names,
)


def _mock_csv_response(header_columns: list[str]):
    raw_line = ",".join(f'"{c}"' for c in header_columns).encode("utf-8")
    lines = [b"meta"] * 5 + [raw_line]
    mock_resp = MagicMock()
    mock_resp.iter_lines.return_value = iter(lines)
    mock_resp.__enter__ = lambda s: s
    mock_resp.__exit__ = MagicMock(return_value=False)
    return mock_resp


class TestGetCsvColumnNames:
    def test_no_duplicates_unchanged(self):
        with patch("app.services.schema_builder.requests.get") as mock_get:
            mock_get.return_value = _mock_csv_response(["SKU", "RateCode", "PricePerUnit"])
            staging_cols, merge_map = get_csv_column_names("http://example.com/test.csv")
        assert staging_cols == ["sku", "rate_code", "price_per_unit"]
        assert merge_map == {}

    def test_duplicate_staging_cols_get_numeric_suffix(self):
        with patch("app.services.schema_builder.requests.get") as mock_get:
            mock_get.return_value = _mock_csv_response(["StorageType", "Storage Type"])
            staging_cols, merge_map = get_csv_column_names("http://example.com/test.csv")
        assert staging_cols == ["storage_type", "storage_type_2"]

    def test_duplicate_produces_merge_map(self):
        with patch("app.services.schema_builder.requests.get") as mock_get:
            mock_get.return_value = _mock_csv_response(["StorageType", "Storage Type"])
            staging_cols, merge_map = get_csv_column_names("http://example.com/test.csv")
        assert merge_map == {"storage_type": ["storage_type", "storage_type_2"]}

    def test_triple_collision(self):
        with patch("app.services.schema_builder.requests.get") as mock_get:
            mock_get.return_value = _mock_csv_response(["Col A", "Col-A", "ColA"])
            staging_cols, merge_map = get_csv_column_names("http://example.com/test.csv")
        assert staging_cols == ["col_a", "col_a_2", "col_a_3"]
        assert merge_map == {"col_a": ["col_a", "col_a_2", "col_a_3"]}

    def test_independent_collision_groups(self):
        with patch("app.services.schema_builder.requests.get") as mock_get:
            mock_get.return_value = _mock_csv_response(
                ["SKU", "Storage Type", "StorageType", "RateCode", "Rate Code"]
            )
            staging_cols, merge_map = get_csv_column_names("http://example.com/test.csv")
        assert staging_cols == ["sku", "storage_type", "storage_type_2", "rate_code", "rate_code_2"]
        assert merge_map == {
            "storage_type": ["storage_type", "storage_type_2"],
            "rate_code": ["rate_code", "rate_code_2"],
        }


class TestColumnDefinition:
    def test_unknown_column_defaults_to_text(self):
        assert _column_definition("description") == '    "description" TEXT'

    def test_rate_code_gets_primary_key(self):
        assert _column_definition("rate_code") == '    "rate_code" TEXT PRIMARY KEY'

    def test_price_per_unit_is_decimal(self):
        assert _column_definition("price_per_unit") == '    "price_per_unit" DECIMAL(20,10)'

    def test_effective_date_is_date(self):
        assert _column_definition("effective_date") == '    "effective_date" DATE'

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
        assert 'CREATE TABLE IF NOT EXISTS "test_ingestion"' in sql

    def test_includes_all_columns(self):
        sql = build_schema_sql("test_ingestion", ["sku", "rate_code", "description"], "20260101")
        assert '"sku" TEXT' in sql
        assert '"rate_code" TEXT PRIMARY KEY' in sql
        assert '"description" TEXT' in sql

    def test_creates_index_for_sku(self):
        sql = build_schema_sql("test_ingestion", ["sku", "rate_code"], "20260101")
        assert "CREATE INDEX" in sql
        assert 'ON "test_ingestion" ("sku")' in sql

    def test_creates_index_for_region_code(self):
        sql = build_schema_sql("test_ingestion", ["rate_code", "region_code"], "20260101")
        assert 'ON "test_ingestion" ("region_code")' in sql

    def test_no_index_for_regular_columns(self):
        sql = build_schema_sql("test_ingestion", ["rate_code", "description"], "20260101")
        assert 'ON "test_ingestion" ("description")' not in sql

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
        assert 'ON "test_ingestion" ("sku")' in sql
        assert 'ON "test_ingestion" ("region_code")' in sql
        assert 'ON "test_ingestion" ("discounted_region_code")' in sql
