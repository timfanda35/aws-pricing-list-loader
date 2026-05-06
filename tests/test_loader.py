from unittest.mock import MagicMock, patch

from app.services.loader import load_pricing_data, _create_ingestion_table, _fetch_all_columns
from app.services.aws_client import BASE_URL


class TestLoadPricingDataForce:
    def test_force_false_loads_known_versions(self):
        known = frozenset([("comprehend", "20240101")])
        with patch("app.services.loader.load_known_versions", return_value=known) as mock_lkv, \
             patch("app.services.loader.get_all_pricing_urls", return_value=[]) as mock_urls:
            load_pricing_data(force=False)
        mock_lkv.assert_called_once_with(None)
        mock_urls.assert_called_once_with(known)

    def test_force_true_skips_known_versions_passes_none(self):
        with patch("app.services.loader.load_known_versions") as mock_lkv, \
             patch("app.services.loader.get_all_pricing_urls", return_value=[]) as mock_urls:
            load_pricing_data(force=True)
        mock_lkv.assert_not_called()
        mock_urls.assert_called_once_with(None)


class TestLoadKnownVersionsNameFilter:
    def test_no_name_passes_none_to_load_known_versions(self):
        known = frozenset([("comprehend", "20240101")])
        with patch("app.services.loader.load_known_versions", return_value=known) as mock_lkv, \
             patch("app.services.loader.get_all_pricing_urls", return_value=[]):
            load_pricing_data(force=False)
        mock_lkv.assert_called_once_with(None)

    def test_name_filter_passed_to_load_known_versions(self):
        known = frozenset([("comprehend", "20240101")])
        with patch("app.services.loader.load_known_versions", return_value=known) as mock_lkv, \
             patch("app.services.loader.get_all_pricing_urls", return_value=[]):
            load_pricing_data(name_filter="comprehend", force=False)
        mock_lkv.assert_called_once_with("comprehend")


class TestCreateIngestionTable:
    def _make_conn(self, ordered_cols):
        mock_cur = MagicMock()
        mock_cur.fetchall.return_value = [(c,) for c in ordered_cols]
        mock_cur.__enter__ = MagicMock(return_value=mock_cur)
        mock_cur.__exit__ = MagicMock(return_value=False)
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cur
        return mock_conn, mock_cur

    def test_uses_provided_columns_not_csv_url(self):
        conn, cur = self._make_conn(["rate_code", "sku"])
        with patch("app.services.loader.get_csv_column_names") as mock_get, \
             patch("app.services.loader.build_schema_sql", return_value="CREATE TABLE t;"):
            _create_ingestion_table(conn, "t_ingestion", ["rate_code", "sku"], "20260101")
        mock_get.assert_not_called()

    def test_calls_build_schema_sql_with_given_columns(self):
        conn, cur = self._make_conn(["rate_code", "sku"])
        with patch("app.services.loader.build_schema_sql", return_value="CREATE TABLE t;") as mock_build:
            _create_ingestion_table(conn, "t_ingestion", ["rate_code", "sku"], "20260101")
        mock_build.assert_called_once_with("t_ingestion", ["rate_code", "sku"], "20260101")

    def test_returns_ordered_columns_from_db(self):
        # DB returns columns in a different order than the input to confirm the
        # return value comes from the DB query, not the input list.
        conn, cur = self._make_conn(["sku", "rate_code"])
        with patch("app.services.loader.build_schema_sql", return_value="CREATE TABLE t;"):
            result = _create_ingestion_table(conn, "t_ingestion", ["rate_code", "sku"], "20260101")
        assert result == ["sku", "rate_code"]


class TestFetchAllColumns:
    def test_calls_get_csv_column_names_for_each_row(self):
        rows = [
            {"csv_url": "/url/a.csv", "name": "svc"},
            {"csv_url": "/url/b.csv", "name": "svc"},
        ]
        cols_map = {
            f"{BASE_URL}/url/a.csv": ["rate_code", "sku"],
            f"{BASE_URL}/url/b.csv": ["rate_code", "region_code"],
        }
        with patch("app.services.loader.get_csv_column_names", side_effect=lambda u: cols_map[u]) as mock_get:
            _fetch_all_columns(rows)
        assert mock_get.call_count == 2

    def test_returns_union_of_all_columns(self):
        rows = [
            {"csv_url": "/url/a.csv", "name": "svc"},
            {"csv_url": "/url/b.csv", "name": "svc"},
        ]
        cols_map = {
            f"{BASE_URL}/url/a.csv": ["rate_code", "sku"],
            f"{BASE_URL}/url/b.csv": ["rate_code", "region_code"],
        }
        with patch("app.services.loader.get_csv_column_names", side_effect=lambda u: cols_map[u]):
            unioned, _ = _fetch_all_columns(rows)
        assert set(unioned) == {"rate_code", "sku", "region_code"}

    def test_first_url_columns_come_first_in_union(self):
        rows = [
            {"csv_url": "/url/a.csv", "name": "svc"},
            {"csv_url": "/url/b.csv", "name": "svc"},
        ]
        cols_map = {
            f"{BASE_URL}/url/a.csv": ["rate_code", "sku"],
            f"{BASE_URL}/url/b.csv": ["rate_code", "extra_col"],
        }
        with patch("app.services.loader.get_csv_column_names", side_effect=lambda u: cols_map[u]):
            unioned, _ = _fetch_all_columns(rows)
        assert unioned[0] == "rate_code"
        assert unioned[1] == "sku"
        assert unioned[2] == "extra_col"

    def test_returns_per_url_column_map(self):
        rows = [
            {"csv_url": "/url/a.csv", "name": "svc"},
            {"csv_url": "/url/b.csv", "name": "svc"},
        ]
        cols_map = {
            f"{BASE_URL}/url/a.csv": ["rate_code", "sku"],
            f"{BASE_URL}/url/b.csv": ["rate_code", "region_code"],
        }
        with patch("app.services.loader.get_csv_column_names", side_effect=lambda u: cols_map[u]):
            _, per_url = _fetch_all_columns(rows)
        assert per_url["/url/a.csv"] == ["rate_code", "sku"]
        assert per_url["/url/b.csv"] == ["rate_code", "region_code"]

    def test_single_url_returns_its_columns_unchanged(self):
        rows = [{"csv_url": "/url/a.csv", "name": "svc"}]
        with patch("app.services.loader.get_csv_column_names", return_value=["rate_code", "sku"]):
            unioned, per_url = _fetch_all_columns(rows)
        assert unioned == ["rate_code", "sku"]
        assert per_url == {"/url/a.csv": ["rate_code", "sku"]}
