import datetime
from flask import Blueprint, request, abort
from app import db
from model import User

bp = Blueprint("hello", __name__, url_prefix="/hello")


@bp.route("/<username>", methods=["GET"])
def get_user(username: str):
    if user := User.query.filter_by(username=username).first():  # type: User
        days = user.days_to_birthday(datetime.date.today())

        if days == 0:
            return f"Hello, {user.username}! Happy birthday!"
        else:
            return f"Hello, {user.username}! Your birthday is in {days} day(s)"
    abort(404)


@bp.route("/<username>", methods=["PUT"])
def update_user(username: str):
    if not request.is_json:
        abort(400)

    data = request.get_json()
    if "dateOfBirth" not in data:
        abort(400)

    date: datetime.date = None
    try:
        date = datetime.datetime.strptime(data["dateOfBirth"], "%Y-%m-%d").date()
    except ValueError:
        abort(400)

    try:
        if user := User.query.filter_by(username=username).first():  # type: User
            user.birthday = date
            db.session.commit()
            return "", 204
        else:
            new_user = User(username=username, birthday=date)
            db.session.add(new_user)
            db.session.commit()
            return "", 201
    except ValueError:
        abort(400)
