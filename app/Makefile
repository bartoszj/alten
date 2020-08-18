.PHONY: init run gunicorn test coverage docker

all: init run

init:
	pipenv run flask init-db

run:
	pipenv run flask run

gunicorn:
	gunicorn "app:create_app()" --access-logfile - --error-logfile -

test:
	pytest

coverage:
	coverage run -m pytest
	coverage report

docker-build:
	docker build -t bartoszj/app .

docker-push: docker-build
	docker image push bartoszj/app
