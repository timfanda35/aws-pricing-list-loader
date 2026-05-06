from unittest.mock import MagicMock, patch
import os

from app.services.loader import load_pricing_data, _create_ingestion_table, _fetch_all_columns, _process_pricing_group
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
        mock_get.assert_any_call(f"{BASE_URL}/url/a.csv")
        mock_get.assert_any_call(f"{BASE_URL}/url/b.csv")

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

    def test_empty_rows_returns_empty(self):
        unioned, per_url = _fetch_all_columns([])
        assert unioned == []
        assert per_url == {}


class TestProcessPricingGroupColumnUnion:
    def _make_tmp(self, name="/tmp/test.csv"):
        mock_tmp = MagicMock()
        mock_tmp.__enter__ = MagicMock(return_value=mock_tmp)
        mock_tmp.__exit__ = MagicMock(return_value=False)
        mock_tmp.name = name
        return mock_tmp

    # Realistic AWS CSV URL pattern: /offers/v1.0/aws/{service}/{version}/...
    _URL_A = "/offers/v1.0/aws/svc/20260101/us-east-1/index.csv"
    _URL_B = "/offers/v1.0/aws/svc/20260101/us-west-2/index.csv"

    def test_fetch_all_columns_called_before_create_ingestion_table(self):
        rows = [
            {"csv_url": self._URL_A, "name": "svc", "region": "us-east-1"},
            {"csv_url": self._URL_B, "name": "svc", "region": "us-west-2"},
        ]
        call_order = []

        def mock_fetch(rows):
            call_order.append("fetch")
            return ["rate_code", "sku"], {self._URL_A: ["rate_code", "sku"], self._URL_B: ["rate_code", "sku"]}

        def mock_create(conn, table, cols, version):
            call_order.append("create")
            return cols

        with patch("app.services.loader.get_db_conn"), \
             patch("app.services.loader._fetch_all_columns", side_effect=mock_fetch), \
             patch("app.services.loader._create_ingestion_table", side_effect=mock_create), \
             patch("app.services.loader._download_csv_strip_header", return_value=1), \
             patch("app.services.loader._copy_csv_to_table"), \
             patch("app.services.loader._swap_tables"), \
             patch("app.services.loader._upsert_version"), \
             patch("app.services.loader.tempfile.NamedTemporaryFile", return_value=self._make_tmp()), \
             patch("app.services.loader.os.path.exists", return_value=False):
            _process_pricing_group(rows)

        assert call_order.index("fetch") < call_order.index("create")

    def test_create_ingestion_table_called_with_unioned_columns(self):
        rows = [{"csv_url": self._URL_A, "name": "svc", "region": "us-east-1"}]
        unioned = ["rate_code", "sku", "extra"]

        with patch("app.services.loader.get_db_conn"), \
             patch("app.services.loader._fetch_all_columns", return_value=(unioned, {self._URL_A: ["rate_code", "sku"]})), \
             patch("app.services.loader._create_ingestion_table", return_value=unioned) as mock_create, \
             patch("app.services.loader._download_csv_strip_header", return_value=1), \
             patch("app.services.loader._copy_csv_to_table"), \
             patch("app.services.loader._swap_tables"), \
             patch("app.services.loader._upsert_version"), \
             patch("app.services.loader.tempfile.NamedTemporaryFile", return_value=self._make_tmp()), \
             patch("app.services.loader.os.path.exists", return_value=False):
            _process_pricing_group(rows)

        # positional: conn, table, columns, version
        assert mock_create.call_args[0][2] == unioned

    def test_copy_uses_per_url_columns_not_unioned(self):
        rows = [{"csv_url": self._URL_A, "name": "svc", "region": "us-east-1"}]
        unioned = ["rate_code", "sku", "extra"]
        per_url = {self._URL_A: ["rate_code", "sku"]}

        copy_cols_used = []

        def mock_copy(conn, table, cols, path):
            copy_cols_used.append(cols)

        with patch("app.services.loader.get_db_conn"), \
             patch("app.services.loader._fetch_all_columns", return_value=(unioned, per_url)), \
             patch("app.services.loader._create_ingestion_table", return_value=unioned), \
             patch("app.services.loader._download_csv_strip_header", return_value=1), \
             patch("app.services.loader._copy_csv_to_table", side_effect=mock_copy), \
             patch("app.services.loader._swap_tables"), \
             patch("app.services.loader._upsert_version"), \
             patch("app.services.loader.tempfile.NamedTemporaryFile", return_value=self._make_tmp()), \
             patch("app.services.loader.os.path.exists", return_value=False):
            _process_pricing_group(rows)

        assert copy_cols_used == [["rate_code", "sku"]]

    def test_copy_falls_back_to_full_columns_when_url_missing_from_per_url(self):
        rows = [{"csv_url": "/offers/v1.0/aws/svc/20260101/us-east-1/index.csv", "name": "svc", "region": "us-east-1"}]
        unioned = ["rate_code", "sku", "extra"]
        per_url = {}  # URL absent from per_url (simulates failed header fetch for this URL)

        copy_cols_used = []

        def mock_copy(conn, table, cols, path):
            copy_cols_used.append(cols)

        with patch("app.services.loader.get_db_conn"), \
             patch("app.services.loader._fetch_all_columns", return_value=(unioned, per_url)), \
             patch("app.services.loader._create_ingestion_table", return_value=unioned), \
             patch("app.services.loader._download_csv_strip_header", return_value=1), \
             patch("app.services.loader._copy_csv_to_table", side_effect=mock_copy), \
             patch("app.services.loader._swap_tables"), \
             patch("app.services.loader._upsert_version"), \
             patch("app.services.loader.tempfile.NamedTemporaryFile", return_value=self._make_tmp()), \
             patch("app.services.loader.os.path.exists", return_value=False):
            _process_pricing_group(rows)

        assert copy_cols_used == [unioned]
