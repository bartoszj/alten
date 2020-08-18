import datetime
from flask import Response


class MockDate1(datetime.date):
    @classmethod
    def today(cls):
        return cls(2020, 8, 8)


class MockDate2(datetime.date):
    @classmethod
    def today(cls):
        return cls(2023, 8, 8)


class MockDate3(datetime.date):
    @classmethod
    def today(cls):
        return cls(2023, 3, 7)


def test_get_date1(monkeypatch, client):
    monkeypatch.setattr(datetime, "date", MockDate1)

    r = client.get("/hello/test")  # type: Response
    assert r.status_code == 200
    assert b"Hello, test! Your birthday is in 211 day(s)" in r.data


def test_get_date2(monkeypatch, client):
    monkeypatch.setattr(datetime, "date", MockDate2)

    r = client.get("/hello/test")  # type: Response
    assert r.status_code == 200
    assert b"Hello, test! Your birthday is in 212 day(s)" in r.data


def test_get_date3(monkeypatch, client):
    monkeypatch.setattr(datetime, "date", MockDate3)

    r = client.get("/hello/test")  # type: Response
    assert r.status_code == 200
    assert b"Hello, test! Happy birthday!" in r.data


def test_get_missing_user(client):
    r = client.get("/hello/asdf")  # type: Response
    assert r.status_code == 404


def test_put_not_json_object(client):
    r = client.put("/hello/someuser")  # type: Response
    assert r.status_code == 400


def test_put_incorrect_json_object(client):
    r = client.put("/hello/someuser", content_type="application/json", data=b"{")  # type: Response
    assert r.status_code == 400


def test_put_missing_birthday(client):
    r = client.put("/hello/someuser", content_type="application/json", data=b"{}")  # type: Response
    assert r.status_code == 400


def test_put_incorrect_birthday(client):
    r = client.put("/hello/someuser", content_type="application/json", data=b"""{"dateOfBirth": "2020-12-1a"}""")  # type: Response
    assert r.status_code == 400


def test_put_create_user(monkeypatch, client):
    monkeypatch.setattr(datetime, "date", MockDate1)
    r = client.put("/hello/someuser", content_type="application/json", data=b"""{"dateOfBirth": "2000-08-09"}""")  # type: Response
    assert r.status_code == 201


def test_put_create_user_incorrect_date(monkeypatch, client):
    monkeypatch.setattr(datetime, "date", MockDate1)
    r = client.put("/hello/someuser", content_type="application/json", data=b"""{"dateOfBirth": "2020-08-09"}""")  # type: Response
    assert r.status_code == 400


def test_put_create_user_incorrect_username(monkeypatch, client):
    monkeypatch.setattr(datetime, "date", MockDate1)
    r = client.put("/hello/someuser2", content_type="application/json", data=b"""{"dateOfBirth": "2020-08-09"}""")  # type: Response
    assert r.status_code == 400


def test_put_update_user(monkeypatch, client):
    monkeypatch.setattr(datetime, "date", MockDate1)
    r = client.put("/hello/test", content_type="application/json", data=b"""{"dateOfBirth": "2000-08-09"}""")  # type: Response
    assert r.status_code == 204
