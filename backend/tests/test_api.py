"""
Integration tests for AccomMap FastAPI backend.
Requires a running PostgreSQL instance (set DATABASE_URL env var).
"""
import pytest
from fastapi.testclient import TestClient
from unittest.mock import patch, MagicMock
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))


@pytest.fixture
def mock_db():
    """Mock database session to avoid needing a live DB for unit tests."""
    with patch("app.database.get_db") as mock:
        db = MagicMock()
        mock.return_value = iter([db])
        yield db


def test_health(mock_db):
    from app.main import app
    client = TestClient(app)
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.json() == {"status": "ok"}


def test_geojson_structure(mock_db):
    from app.main import app
    mock_db.execute.return_value.mappings.return_value.all.return_value = []
    client = TestClient(app)
    resp = client.get("/api/map/geojson")
    assert resp.status_code == 200
    data = resp.json()
    assert data["type"] == "FeatureCollection"
    assert "features" in data


def test_listings_pagination(mock_db):
    from app.main import app
    mock_db.execute.return_value.mappings.return_value.all.return_value = []
    mock_db.execute.return_value.scalar.return_value = 0
    client = TestClient(app)
    resp = client.get("/api/listings?limit=10&offset=0")
    assert resp.status_code == 200
    data = resp.json()
    assert "total" in data
    assert "items" in data


def test_listings_invalid_limit(mock_db):
    from app.main import app
    client = TestClient(app)
    # limit > 500 should be rejected
    resp = client.get("/api/listings?limit=9999")
    assert resp.status_code == 422
