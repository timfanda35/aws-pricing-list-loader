from unittest.mock import patch

from app.services.loader import load_pricing_data


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
