import pytest
from unittest.mock import patch

from app.services.aws_client import (
    fetch_savings_plan_pricing_urls,
    fetch_service_pricing_urls,
    to_snake_case,
)


@pytest.mark.parametrize("name, expected", [
    ("AmazonEC2", "amazon_ec2"),
    ("AWSDatabaseSavingsPlans", "aws_database_savings_plans"),
    ("AWSMachineLearningSavingsPlans", "aws_machine_learning_savings_plans"),
    ("AWSComputeSavingsPlan", "aws_compute_savings_plan"),
    ("Amazon Bedrock", "amazon_bedrock"),
    ("aws-comprehend", "aws_comprehend"),
    ("amazon_bedrock", "amazon_bedrock"),
    ("AmazonRDS", "amazon_rds"),
])
def test_to_snake_case(name, expected):
    assert to_snake_case(name) == expected


_REGION_INDEX = {
    "publicationDate": "2024-01-01",
    "regions": {
        "us-east-1": {
            "currentVersionUrl": "/offers/v1.0/aws/AmazonEC2/20240101/us-east-1/index.json"
        }
    },
}

_SAVINGS_PLAN_REGION_INDEX = {
    "publicationDate": "2024-01-01",
    "regions": [
        {
            "regionCode": "us-east-1",
            "versionUrl": "/savingsPlan/v1.0/aws/AWSComputeSavingsPlan/20240101/us-east-1/index.json",
        }
    ],
}


class TestFetchServicePricingUrlsVersionCheck:
    def test_known_version_skipped_when_in_set(self):
        known = frozenset([("amazon_ec2", "20240101")])
        with patch("app.services.aws_client.fetch_json", return_value=_REGION_INDEX):
            results = fetch_service_pricing_urls("AmazonEC2", "/some/path", known)
        assert results == []

    def test_known_version_not_skipped_when_known_versions_is_none(self):
        with patch("app.services.aws_client.fetch_json", return_value=_REGION_INDEX):
            results = fetch_service_pricing_urls("AmazonEC2", "/some/path", None)
        assert len(results) == 1


class TestFetchSavingsPlanPricingUrlsVersionCheck:
    def test_known_version_skipped_when_in_set(self):
        path = "/savingsPlan/v1.0/aws/AWSComputeSavingsPlan/current/region_index.json"
        known = frozenset([("aws_compute_savings_plan", "20240101")])
        with patch("app.services.aws_client.fetch_json", return_value=_SAVINGS_PLAN_REGION_INDEX):
            results = fetch_savings_plan_pricing_urls(path, known)
        assert results == []

    def test_known_version_not_skipped_when_known_versions_is_none(self):
        path = "/savingsPlan/v1.0/aws/AWSComputeSavingsPlan/current/region_index.json"
        with patch("app.services.aws_client.fetch_json", return_value=_SAVINGS_PLAN_REGION_INDEX):
            results = fetch_savings_plan_pricing_urls(path, None)
        assert len(results) == 1
