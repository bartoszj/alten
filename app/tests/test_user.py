import pytest
from datetime import date, timedelta
from sqlalchemy.exc import IntegrityError
from app import db
from model import User


@pytest.mark.parametrize(
    "username", ["another", "SomethingElse", "veryyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyLongggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg"]
)
def test_add_a_user(app, username):
    with app.app_context():
        user = User(username=username, birthday=date.today())
        db.session.add(user)
        db.session.commit()


def test_add_existing_user(app):
    with app.app_context():
        user = User(username="test", birthday=date.today())
        db.session.add(user)
        with pytest.raises(IntegrityError):
            db.session.commit()


@pytest.mark.parametrize(
    "username", ["test12", "name with space", "12312"]
)
def test_add_incorrect_username(app, username):
    with app.app_context():
        with pytest.raises(ValueError):
            user = User(username=username, birthday=date.today())
            db.session.add(user)
            db.session.commit()


@pytest.mark.parametrize(
    "birthday", [date.today(), date.today()-timedelta(days=1)]
)
def test_use_correct_birthday(app, birthday):
    with app.app_context():
        user = User(username="someUser", birthday=birthday)
        db.session.add(user)
        db.session.commit()


@pytest.mark.parametrize(
    "birthday", [date.today()+timedelta(days=1)]
)
def test_use_incorrect_birthday(app, birthday):
    with app.app_context():
        with pytest.raises(ValueError):
            user = User(username="someUser", birthday=birthday)
            db.session.add(user)
            db.session.commit()


@pytest.mark.parametrize(
    "birthday,today,days", [
        (date.today(), date.today(), 0),
        (date(year=date.today().year-1, month=date.today().month, day=date.today().day+1), date.today(), 1),
        (date(year=1947, month=3, day=25), date(year=2020, month=8, day=8), 229),
        (date(year=1947, month=3, day=25), date(year=2023, month=8, day=8), 230),
    ]
)
def test_days_to_birthday(app, birthday, today, days):
    with app.app_context():
        user = User(username="someUser", birthday=birthday)
        assert user.days_to_birthday(today) == days
