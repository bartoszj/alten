import datetime
from app import db


class User(db.Model):
    __tablename__ = "user"

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.Text, unique=True, nullable=False)
    birthday = db.Column(db.Date, nullable=False)

    def __repr__(self):
        return f"<User {self.username}>"

    @db.validates("username")
    def validate_username(self, key: str, username: str) -> str:
        if not username.isalpha():
            raise ValueError("Username must contain only letters")
        return username

    @db.validates("birthday")
    def validate_birthday(self, key: str, birthday: datetime.date) -> datetime.date:
        if birthday > datetime.date.today():
            raise ValueError("Birthdate must be before current date")
        return birthday

    def days_to_birthday(self, date: datetime.date) -> int:
        d1 = datetime.date(date.year, self.birthday.month, self.birthday.day) - date
        d2 = datetime.date(date.year + 1, self.birthday.month, self.birthday.day) - date
        return d1.days if d1.days >= 0 else d2.days
