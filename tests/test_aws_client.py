import pytest

from app.services.aws_client import to_snake_case


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
