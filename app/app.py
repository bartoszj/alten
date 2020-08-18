import click
import os
from flask import Flask
from flask.cli import with_appcontext
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


def create_app(config: dict = None):
    app = Flask(__name__)

    db_url = os.environ.get("DATABASE_URL")
    if db_url is None:
        db_path = os.path.join(app.root_path, "db.sqlite3")
        db_url = f"sqlite:///{db_path}"
        os.makedirs(app.root_path, exist_ok=True)

    app.config.from_mapping(
        SECRET_KEY=os.environ.get("SECRET_KEY", "dev"),
        SQLALCHEMY_DATABASE_URI=db_url,
        SQLALCHEMY_TRACK_MODIFICATIONS=False,
    )

    if config is not None:
        app.config.update(config)

    db.init_app(app)
    app.cli.add_command(init_db_command)

    # Blueprint
    from views import bp as views_bp
    from health import bp as health_bp
    app.register_blueprint(views_bp)
    app.register_blueprint(health_bp)

    return app


def init_db():
    db.drop_all()
    db.create_all()


@click.command("init-db")
@with_appcontext
def init_db_command():
    """Clear existing data and create new tables."""
    init_db()
    click.echo("Initialized the database.")
