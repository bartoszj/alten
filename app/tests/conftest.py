import pytest
from datetime import date
from app import create_app, db, init_db
from model import User


@pytest.fixture
def app():
    app = create_app({"TESTING": True, "SQLALCHEMY_DATABASE_URI": "sqlite:///:memory:"})

    with app.app_context():
        init_db()
        user = User(username="test", birthday=date(1962, 3, 7))
        db.session.add(user)
        db.session.commit()

    yield app


@pytest.fixture
def client(app):
    return app.test_client()
