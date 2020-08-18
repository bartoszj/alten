from flask import Response


def test_ready(client):
    r = client.get("/ready")  # type: Response
    assert r.status_code == 200
    assert r.data == b""
