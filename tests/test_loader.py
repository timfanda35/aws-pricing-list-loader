from unittest.mock import MagicMock, patch
import os

from app.services.loader import load_pricing_data, _create_ingestion_table, _fetch_all_columns, _process_pricing_group, _copy_csv_to_table
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


def _cols(cols, mm=None):
    """Helper: simulate get_csv_column_names return value."""
    return cols, mm or {}


class TestFetchAllColumns:
    def test_calls_get_csv_column_names_for_each_row(self):
        rows = [
            {"csv_url": "/url/a.csv", "name": "svc"},
            {"csv_url": "/url/b.csv", "name": "svc"},
        ]
        cols_map = {
            f"{BASE_URL}/url/a.csv": _cols(["rate_code", "sku"]),
            f"{BASE_URL}/url/b.csv": _cols(["rate_code", "region_code"]),
        }
        with patch("app.services.loader.get_csv_column_names", side_effect=lambda u: cols_map[u]) as mock_get:
            _fetch_all_columns(rows)
        mock_get.assert_any_call(f"{BASE_URL}/url/a.csv")
        mock_get.assert_any_call(f"{BASE_URL}/url/b.csv")

    def test_returns_union_of_all_staging_columns(self):
        rows = [
            {"csv_url": "/url/a.csv", "name": "svc"},
            {"csv_url": "/url/b.csv", "name": "svc"},
        ]
        cols_map = {
            f"{BASE_URL}/url/a.csv": _cols(["rate_code", "sku"]),
            f"{BASE_URL}/url/b.csv": _cols(["rate_code", "region_code"]),
        }
        with patch("app.services.loader.get_csv_column_names", side_effect=lambda u: cols_map[u]):
            staging, ingestion, merge_map, _ = _fetch_all_columns(rows)
        assert set(staging) == {"rate_code", "sku", "region_code"}
        assert set(ingestion) == {"rate_code", "sku", "region_code"}
        assert merge_map == {}

    def test_first_url_columns_come_first_in_union(self):
        rows = [
            {"csv_url": "/url/a.csv", "name": "svc"},
            {"csv_url": "/url/b.csv", "name": "svc"},
        ]
        cols_map = {
            f"{BASE_URL}/url/a.csv": _cols(["rate_code", "sku"]),
            f"{BASE_URL}/url/b.csv": _cols(["rate_code", "extra_col"]),
        }
        with patch("app.services.loader.get_csv_column_names", side_effect=lambda u: cols_map[u]):
            staging, _, _, _ = _fetch_all_columns(rows)
        assert staging[0] == "rate_code"
        assert staging[1] == "sku"
        assert staging[2] == "extra_col"

    def test_returns_per_url_staging_column_map(self):
        rows = [
            {"csv_url": "/url/a.csv", "name": "svc"},
            {"csv_url": "/url/b.csv", "name": "svc"},
        ]
        cols_map = {
            f"{BASE_URL}/url/a.csv": _cols(["rate_code", "sku"]),
            f"{BASE_URL}/url/b.csv": _cols(["rate_code", "region_code"]),
        }
        with patch("app.services.loader.get_csv_column_names", side_effect=lambda u: cols_map[u]):
            _, _, _, per_url = _fetch_all_columns(rows)
        assert per_url["/url/a.csv"] == ["rate_code", "sku"]
        assert per_url["/url/b.csv"] == ["rate_code", "region_code"]

    def test_single_url_returns_its_columns_unchanged(self):
        rows = [{"csv_url": "/url/a.csv", "name": "svc"}]
        with patch("app.services.loader.get_csv_column_names", return_value=_cols(["rate_code", "sku"])):
            staging, ingestion, merge_map, per_url = _fetch_all_columns(rows)
        assert staging == ["rate_code", "sku"]
        assert ingestion == ["rate_code", "sku"]
        assert merge_map == {}
        assert per_url == {"/url/a.csv": ["rate_code", "sku"]}

    def test_empty_rows_returns_empty(self):
        staging, ingestion, merge_map, per_url = _fetch_all_columns([])
        assert staging == []
        assert ingestion == []
        assert merge_map == {}
        assert per_url == {}

    def test_duplicate_columns_excluded_from_ingestion_cols(self):
        rows = [{"csv_url": "/url/a.csv", "name": "svc"}]
        mm = {"storage_type": ["storage_type", "storage_type_2"]}
        with patch("app.services.loader.get_csv_column_names",
                   return_value=(["rate_code", "storage_type", "storage_type_2"], mm)):
            staging, ingestion, merge_map, _ = _fetch_all_columns(rows)
        assert staging == ["rate_code", "storage_type", "storage_type_2"]
        assert ingestion == ["rate_code", "storage_type"]
        assert merge_map == mm

    def test_merge_maps_aggregated_across_regions(self):
        rows = [
            {"csv_url": "/url/a.csv", "name": "svc"},
            {"csv_url": "/url/b.csv", "name": "svc"},
        ]
        mm_a = {"storage_type": ["storage_type", "storage_type_2"]}
        mm_b = {}
        cols_map = {
            f"{BASE_URL}/url/a.csv": (["rate_code", "storage_type", "storage_type_2"], mm_a),
            f"{BASE_URL}/url/b.csv": (["rate_code", "storage_type"], mm_b),
        }
        with patch("app.services.loader.get_csv_column_names", side_effect=lambda u: cols_map[u]):
            _, ingestion, merge_map, _ = _fetch_all_columns(rows)
        assert "storage_type_2" not in ingestion
        assert "storage_type" in ingestion
        assert merge_map == {"storage_type": ["storage_type", "storage_type_2"]}


class TestProcessPricingGroupColumnUnion:
    def _make_tmp(self, name="/tmp/test.csv"):
        mock_tmp = MagicMock()
        mock_tmp.__enter__ = MagicMock(return_value=mock_tmp)
        mock_tmp.__exit__ = MagicMock(return_value=False)
        mock_tmp.name = name
        return mock_tmp

    _URL_A = "/offers/v1.0/aws/svc/20260101/us-east-1/index.csv"
    _URL_B = "/offers/v1.0/aws/svc/20260101/us-west-2/index.csv"
    _EMPTY_FETCH = ([], [], {}, {})

    def _fetch_return(self, staging, ingestion=None, merge_map=None, per_url=None):
        return (staging, ingestion or staging, merge_map or {}, per_url or {self._URL_A: staging})

    def test_fetch_all_columns_called_before_create_ingestion_table(self):
        rows = [
            {"csv_url": self._URL_A, "name": "svc", "region": "us-east-1"},
            {"csv_url": self._URL_B, "name": "svc", "region": "us-west-2"},
        ]
        call_order = []

        def mock_fetch(rows):
            call_order.append("fetch")
            return self._fetch_return(["rate_code", "sku"])

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

    def test_create_ingestion_table_called_with_ingestion_cols(self):
        rows = [{"csv_url": self._URL_A, "name": "svc", "region": "us-east-1"}]
        ingestion = ["rate_code", "sku"]
        staging = ["rate_code", "sku", "sku_2"]
        mm = {"sku": ["sku", "sku_2"]}

        with patch("app.services.loader.get_db_conn"), \
             patch("app.services.loader._fetch_all_columns",
                   return_value=(staging, ingestion, mm, {self._URL_A: staging})), \
             patch("app.services.loader._create_ingestion_table", return_value=ingestion) as mock_create, \
             patch("app.services.loader._download_csv_strip_header", return_value=1), \
             patch("app.services.loader._copy_csv_to_table"), \
             patch("app.services.loader._swap_tables"), \
             patch("app.services.loader._upsert_version"), \
             patch("app.services.loader.tempfile.NamedTemporaryFile", return_value=self._make_tmp()), \
             patch("app.services.loader.os.path.exists", return_value=False):
            _process_pricing_group(rows)

        assert mock_create.call_args[0][2] == ingestion

    def test_copy_uses_per_url_staging_cols(self):
        rows = [{"csv_url": self._URL_A, "name": "svc", "region": "us-east-1"}]
        staging = ["rate_code", "sku", "storage_type", "storage_type_2"]
        ingestion = ["rate_code", "sku", "storage_type"]
        mm = {"storage_type": ["storage_type", "storage_type_2"]}
        per_url = {self._URL_A: staging}

        copy_args_used = []

        def mock_copy(conn, table, staging_cols, merge_map, path, region):
            copy_args_used.append((staging_cols, merge_map))

        with patch("app.services.loader.get_db_conn"), \
             patch("app.services.loader._fetch_all_columns",
                   return_value=(staging, ingestion, mm, per_url)), \
             patch("app.services.loader._create_ingestion_table", return_value=ingestion), \
             patch("app.services.loader._download_csv_strip_header", return_value=1), \
             patch("app.services.loader._copy_csv_to_table", side_effect=mock_copy), \
             patch("app.services.loader._swap_tables"), \
             patch("app.services.loader._upsert_version"), \
             patch("app.services.loader.tempfile.NamedTemporaryFile", return_value=self._make_tmp()), \
             patch("app.services.loader.os.path.exists", return_value=False):
            _process_pricing_group(rows)

        assert copy_args_used == [(staging, mm)]

    def test_copy_falls_back_to_full_staging_when_url_missing_from_per_url(self):
        rows = [{"csv_url": self._URL_A, "name": "svc", "region": "us-east-1"}]
        staging = ["rate_code", "sku"]
        ingestion = ["rate_code", "sku"]
        mm = {}

        copy_args_used = []

        def mock_copy(conn, table, staging_cols, merge_map, path, region):
            copy_args_used.append(staging_cols)

        with patch("app.services.loader.get_db_conn"), \
             patch("app.services.loader._fetch_all_columns",
                   return_value=(staging, ingestion, mm, {})), \
             patch("app.services.loader._create_ingestion_table", return_value=ingestion), \
             patch("app.services.loader._download_csv_strip_header", return_value=1), \
             patch("app.services.loader._copy_csv_to_table", side_effect=mock_copy), \
             patch("app.services.loader._swap_tables"), \
             patch("app.services.loader._upsert_version"), \
             patch("app.services.loader.tempfile.NamedTemporaryFile", return_value=self._make_tmp()), \
             patch("app.services.loader.os.path.exists", return_value=False):
            _process_pricing_group(rows)

        assert copy_args_used == [staging]


class TestCopyCsvToTable:
    def _make_conn(self):
        mock_cur = MagicMock()
        mock_cur.__enter__ = MagicMock(return_value=mock_cur)
        mock_cur.__exit__ = MagicMock(return_value=False)
        mock_conn = MagicMock()
        mock_conn.cursor.return_value = mock_cur
        return mock_conn, mock_cur

    def test_copies_via_staging_table(self, tmp_path):
        csv_file = tmp_path / "test.csv"
        csv_file.write_bytes(b'"rate1","sku1"\n')

        conn, cur = self._make_conn()
        _copy_csv_to_table(conn, "svc_ingestion", ["rate_code", "sku"], {}, str(csv_file), "us-east-1")

        execute_calls = [str(c.args[0]) for c in cur.execute.call_args_list]
        assert any('DROP TABLE IF EXISTS "svc_ingestion_us_east_1_staging"' in s for s in execute_calls)
        assert any('CREATE UNLOGGED TABLE "svc_ingestion_us_east_1_staging"' in s for s in execute_calls)
        assert any('ON CONFLICT (rate_code, pricing_region) DO NOTHING' in s for s in execute_calls)
        assert 'DROP TABLE IF EXISTS "svc_ingestion_us_east_1_staging"' in execute_calls[-1]

    def test_copy_targets_staging_not_ingestion(self, tmp_path):
        csv_file = tmp_path / "test.csv"
        csv_file.write_bytes(b'"rate1","sku1"\n')

        conn, cur = self._make_conn()
        _copy_csv_to_table(conn, "svc_ingestion", ["rate_code", "sku"], {}, str(csv_file), "us-east-1")

        copy_expert_calls = [str(c.args[0]) for c in cur.copy_expert.call_args_list]
        assert len(copy_expert_calls) == 1
        assert '"svc_ingestion_us_east_1_staging"' in copy_expert_calls[0]
        assert '"svc_ingestion"' not in copy_expert_calls[0]

    def test_insert_uses_on_conflict_do_nothing(self, tmp_path):
        csv_file = tmp_path / "test.csv"
        csv_file.write_bytes(b'"rate1","sku1"\n')

        conn, cur = self._make_conn()
        _copy_csv_to_table(conn, "svc_ingestion", ["rate_code", "sku"], {}, str(csv_file), "us-east-1")

        insert_calls = [str(c.args[0]) for c in cur.execute.call_args_list
                        if 'INSERT INTO' in str(c.args[0])]
        assert len(insert_calls) == 1
        assert '"svc_ingestion"' in insert_calls[0]
        assert 'FROM "svc_ingestion_us_east_1_staging"' in insert_calls[0]
        assert 'ON CONFLICT (rate_code, pricing_region) DO NOTHING' in insert_calls[0]

    def test_commits_after_insert(self, tmp_path):
        csv_file = tmp_path / "test.csv"
        csv_file.write_bytes(b'"rate1","sku1"\n')

        conn, cur = self._make_conn()
        _copy_csv_to_table(conn, "svc_ingestion", ["rate_code", "sku"], {}, str(csv_file), "us-east-1")

        conn.commit.assert_called_once()

    def test_coalesce_generated_for_duplicate_columns(self, tmp_path):
        csv_file = tmp_path / "test.csv"
        csv_file.write_bytes(b'"rate1","val",""\n')

        conn, cur = self._make_conn()
        mm = {"storage_type": ["storage_type", "storage_type_2"]}
        _copy_csv_to_table(
            conn, "svc_ingestion",
            ["rate_code", "storage_type", "storage_type_2"],
            mm, str(csv_file), "us-east-1",
        )

        insert_calls = [str(c.args[0]) for c in cur.execute.call_args_list
                        if 'INSERT INTO' in str(c.args[0])]
        assert len(insert_calls) == 1
        assert 'COALESCE("storage_type", "storage_type_2")' in insert_calls[0]
        # storage_type_2 must not appear in the INSERT target column list
        insert_col_list = insert_calls[0].split('SELECT')[0]
        assert '"storage_type_2"' not in insert_col_list

    def test_staging_table_has_all_staging_cols_including_duplicates(self, tmp_path):
        csv_file = tmp_path / "test.csv"
        csv_file.write_bytes(b'"rate1","val",""\n')

        conn, cur = self._make_conn()
        mm = {"storage_type": ["storage_type", "storage_type_2"]}
        _copy_csv_to_table(
            conn, "svc_ingestion",
            ["rate_code", "storage_type", "storage_type_2"],
            mm, str(csv_file), "us-east-1",
        )

        create_calls = [str(c.args[0]) for c in cur.execute.call_args_list
                        if 'CREATE UNLOGGED' in str(c.args[0])]
        assert len(create_calls) == 1
        assert '"storage_type_2"' in create_calls[0]
        assert '"pricing_region"' in create_calls[0]
