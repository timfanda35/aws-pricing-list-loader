from unittest.mock import patch

from fastapi.testclient import TestClient

from app.main import app


def test_lifespan_runs_migrations_on_startup():
    with patch("app.main.run_migrations") as mock_run:
        with TestClient(app):
            mock_run.assert_called_once()
