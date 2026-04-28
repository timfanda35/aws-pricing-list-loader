from unittest.mock import patch

import pytest
from fastapi.testclient import TestClient

from app.main import app
from app.services.aws_client import BASE_URL

client = TestClient(app)

_MOCK_URL = {
    "type": "service",
    "name": "AmazonEC2",
    "region": "us-east-1",
    "csv_url": "/offers/v1.0/aws/AmazonEC2/20260101/region/us-east-1/index.csv",
    "publication_date": "2026-01-01T00:00:00Z",
    "region_index_path": "/offers/v1.0/aws/AmazonEC2/current/region_index.json",
}


class TestListPricingUrls:
    def test_returns_200(self):
        with patch("app.routers.pricing.load_known_versions", return_value=frozenset()), \
             patch("app.routers.pricing.get_all_pricing_urls", return_value=[_MOCK_URL]), \
             patch("app.routers.pricing.generate_missing_schemas"):
            response = client.get("/pricing/urls")
        assert response.status_code == 200

    def test_returns_list_of_urls(self):
        with patch("app.routers.pricing.load_known_versions", return_value=frozenset()), \
             patch("app.routers.pricing.get_all_pricing_urls", return_value=[_MOCK_URL]), \
             patch("app.routers.pricing.generate_missing_schemas"):
            response = client.get("/pricing/urls")
        data = response.json()
        assert len(data) == 1
        assert data[0]["name"] == "AmazonEC2"
        assert data[0]["type"] == "service"
        assert data[0]["region"] == "us-east-1"

    def test_csv_url_has_base_url_prepended(self):
        with patch("app.routers.pricing.load_known_versions", return_value=frozenset()), \
             patch("app.routers.pricing.get_all_pricing_urls", return_value=[_MOCK_URL]), \
             patch("app.routers.pricing.generate_missing_schemas"):
            response = client.get("/pricing/urls")
        data = response.json()
        assert data[0]["csv_url"].startswith(BASE_URL)

    def test_empty_result_returns_empty_list(self):
        with patch("app.routers.pricing.load_known_versions", return_value=frozenset()), \
             patch("app.routers.pricing.get_all_pricing_urls", return_value=[]), \
             patch("app.routers.pricing.generate_missing_schemas"):
            response = client.get("/pricing/urls")
        assert response.json() == []


class TestTriggerLoad:
    def test_returns_200(self):
        mock_result = {"loaded": 14, "services": 1, "elapsed_seconds": 5.0}
        with patch("app.routers.pricing.load_pricing_data", return_value=mock_result):
            response = client.post("/pricing/load")
        assert response.status_code == 200

    def test_returns_load_result_fields(self):
        mock_result = {"loaded": 14, "services": 1, "elapsed_seconds": 5.5}
        with patch("app.routers.pricing.load_pricing_data", return_value=mock_result):
            response = client.post("/pricing/load")
        data = response.json()
        assert data["loaded"] == 14
        assert data["services"] == 1
        assert data["elapsed_seconds"] == 5.5

    def test_no_body_loads_all_services(self):
        mock_result = {"loaded": 100, "services": 10, "elapsed_seconds": 60.0}
        with patch("app.routers.pricing.load_pricing_data", return_value=mock_result) as mock_fn:
            client.post("/pricing/load")
        mock_fn.assert_called_once_with(name_filter=None)

    def test_name_filter_passed_to_service(self):
        mock_result = {"loaded": 14, "services": 1, "elapsed_seconds": 5.0}
        with patch("app.routers.pricing.load_pricing_data", return_value=mock_result) as mock_fn:
            client.post("/pricing/load", json={"name": "comprehend"})
        mock_fn.assert_called_once_with(name_filter="comprehend")

    def test_nothing_loaded_returns_zeros(self):
        mock_result = {"loaded": 0, "services": 0, "elapsed_seconds": 0.5}
        with patch("app.routers.pricing.load_pricing_data", return_value=mock_result):
            response = client.post("/pricing/load")
        data = response.json()
        assert data["loaded"] == 0
        assert data["services"] == 0


class TestListVersions:
    def test_returns_200(self):
        with patch("app.routers.versions.get_all_versions", return_value=[]):
            response = client.get("/versions")
        assert response.status_code == 200

    def test_returns_version_list(self):
        mock_versions = [
            {"name": "amazon_ec2", "version": "20260101"},
            {"name": "comprehend", "version": "20260116"},
        ]
        with patch("app.routers.versions.get_all_versions", return_value=mock_versions):
            response = client.get("/versions")
        data = response.json()
        assert len(data) == 2
        assert data[0]["name"] == "amazon_ec2"
        assert data[0]["version"] == "20260101"
        assert data[1]["name"] == "comprehend"

    def test_empty_versions_returns_empty_list(self):
        with patch("app.routers.versions.get_all_versions", return_value=[]):
            response = client.get("/versions")
        assert response.json() == []


class TestHealth:
    def test_returns_200(self):
        response = client.get("/health")
        assert response.status_code == 200

    def test_returns_ok_body(self):
        response = client.get("/health")
        assert response.json() == {"status": "ok"}
