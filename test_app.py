from unittest.mock import MagicMock, patch

from fastapi.testclient import TestClient

from app import app

client = TestClient(app)


def test_api_up():
    with patch("app.requests.get", return_value=MagicMock(status_code=200)):
        assert client.get("/api/health").json() == {"up": True}


def test_api_down():
    with patch("app.requests.get", return_value=MagicMock(status_code=500)):
        assert client.get("/api/health").json() == {"up": False}


def test_index():
    with patch("app.requests.get", return_value=MagicMock(status_code=200)):
        res = client.get("/")
        assert res.status_code == 200 and "UP" in res.text
