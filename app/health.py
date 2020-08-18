from flask import Blueprint, request, abort

bp = Blueprint("health", __name__)


@bp.route("/ready")
def ready():
    return "", 200
