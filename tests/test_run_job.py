import pytest
from unittest.mock import MagicMock, patch

import run_job as rj


MOCK_RESULT = {"loaded": 5, "services": 2, "elapsed_seconds": 3.14}
MOCK_URLS = [{"type": "service", "name": "comprehend", "region": "us-east-1", "csv_url": "/url", "publication_date": "2024-01-01"}]
KNOWN = frozenset([("comprehend", "20240101")])


class TestStepSequencing:
    def test_steps_execute_in_order(self):
        call_order = []
        with patch("run_job.run_migrations", side_effect=lambda: call_order.append("migrations")), \
             patch("run_job.load_known_versions", side_effect=lambda n: call_order.append("load_known") or KNOWN), \
             patch("run_job.get_all_pricing_urls", side_effect=lambda k: call_order.append("get_urls") or MOCK_URLS), \
             patch("run_job.load_pricing_data", side_effect=lambda **kw: call_order.append("load") or MOCK_RESULT):
            rj.run_job()
        assert call_order == ["migrations", "load_known", "get_urls", "load"]


class TestExitOnFailure:
    def test_exits_1_if_migration_raises(self):
        with patch("run_job.run_migrations", side_effect=RuntimeError("boom")), \
             pytest.raises(SystemExit) as exc:
            rj.run_job()
        assert exc.value.code == 1

    def test_exits_1_if_get_all_pricing_urls_raises(self):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions", return_value=KNOWN), \
             patch("run_job.get_all_pricing_urls", side_effect=RuntimeError("boom")), \
             pytest.raises(SystemExit) as exc:
            rj.run_job()
        assert exc.value.code == 1

    def test_exits_1_if_load_pricing_data_raises(self):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions", return_value=KNOWN), \
             patch("run_job.get_all_pricing_urls", return_value=MOCK_URLS), \
             patch("run_job.load_pricing_data", side_effect=RuntimeError("boom")), \
             pytest.raises(SystemExit) as exc:
            rj.run_job()
        assert exc.value.code == 1

    def test_does_not_call_load_if_migration_fails(self):
        with patch("run_job.run_migrations", side_effect=RuntimeError("boom")), \
             patch("run_job.load_pricing_data") as mock_load, \
             pytest.raises(SystemExit):
            rj.run_job()
        mock_load.assert_not_called()


class TestForceFlag:
    def test_force_false_calls_load_known_versions(self):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions", return_value=KNOWN) as mock_lkv, \
             patch("run_job.get_all_pricing_urls", return_value=MOCK_URLS), \
             patch("run_job.load_pricing_data", return_value=MOCK_RESULT):
            rj.run_job(force=False)
        mock_lkv.assert_called_once_with(None)

    def test_force_true_skips_load_known_versions(self):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions") as mock_lkv, \
             patch("run_job.get_all_pricing_urls", return_value=MOCK_URLS), \
             patch("run_job.load_pricing_data", return_value=MOCK_RESULT):
            rj.run_job(force=True)
        mock_lkv.assert_not_called()

    def test_force_true_passes_none_to_get_all_pricing_urls(self):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions"), \
             patch("run_job.get_all_pricing_urls", return_value=MOCK_URLS) as mock_urls, \
             patch("run_job.load_pricing_data", return_value=MOCK_RESULT):
            rj.run_job(force=True)
        mock_urls.assert_called_once_with(None)

    def test_force_true_passes_force_to_load_pricing_data(self):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions", return_value=KNOWN), \
             patch("run_job.get_all_pricing_urls", return_value=MOCK_URLS), \
             patch("run_job.load_pricing_data", return_value=MOCK_RESULT) as mock_load:
            rj.run_job(force=True)
        mock_load.assert_called_once_with(name_filter=None, force=True)

    def test_force_false_passes_force_false_to_load_pricing_data(self):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions", return_value=KNOWN), \
             patch("run_job.get_all_pricing_urls", return_value=MOCK_URLS), \
             patch("run_job.load_pricing_data", return_value=MOCK_RESULT) as mock_load:
            rj.run_job(force=False)
        mock_load.assert_called_once_with(name_filter=None, force=False)


class TestNameFilter:
    def test_name_passed_to_load_known_versions(self):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions", return_value=KNOWN) as mock_lkv, \
             patch("run_job.get_all_pricing_urls", return_value=MOCK_URLS), \
             patch("run_job.load_pricing_data", return_value=MOCK_RESULT):
            rj.run_job(name="comprehend")
        mock_lkv.assert_called_once_with("comprehend")

    def test_name_passed_to_load_pricing_data(self):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions", return_value=KNOWN), \
             patch("run_job.get_all_pricing_urls", return_value=MOCK_URLS), \
             patch("run_job.load_pricing_data", return_value=MOCK_RESULT) as mock_load:
            rj.run_job(name="comprehend")
        mock_load.assert_called_once_with(name_filter="comprehend", force=False)

    def test_none_name_passes_none(self):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions", return_value=KNOWN) as mock_lkv, \
             patch("run_job.get_all_pricing_urls", return_value=MOCK_URLS), \
             patch("run_job.load_pricing_data", return_value=MOCK_RESULT) as mock_load:
            rj.run_job(name=None)
        mock_lkv.assert_called_once_with(None)
        mock_load.assert_called_once_with(name_filter=None, force=False)


class TestStderrOutput:
    def test_step_headers_in_stderr(self, capsys):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions", return_value=KNOWN), \
             patch("run_job.get_all_pricing_urls", return_value=MOCK_URLS), \
             patch("run_job.load_pricing_data", return_value=MOCK_RESULT):
            rj.run_job()
        err = capsys.readouterr().err
        assert "[Step 1/3]" in err
        assert "[Step 2/3]" in err
        assert "[Step 3/3]" in err

    def test_final_summary_shows_result(self, capsys):
        with patch("run_job.run_migrations"), \
             patch("run_job.load_known_versions", return_value=KNOWN), \
             patch("run_job.get_all_pricing_urls", return_value=MOCK_URLS), \
             patch("run_job.load_pricing_data", return_value={"loaded": 7, "services": 3, "elapsed_seconds": 1.5}):
            rj.run_job()
        err = capsys.readouterr().err
        assert "7" in err
        assert "3" in err
        assert "1.5" in err
