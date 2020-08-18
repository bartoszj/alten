# Dependencies stage
FROM python:3.8 AS builder
RUN pip install pipenv

COPY Pipfile .
COPY Pipfile.lock .
RUN pipenv lock --requirements > requirements.txt

# Install dependencies to the local user directory (eg. /root/.local)
RUN pip install --user -r requirements.txt


# App stage
FROM python:3.8-slim
WORKDIR /app
RUN apt-get update \
 && apt-get install -y libpq5 \
 && rm -rf /var/lib/apt/lists/*

# Copy only the dependencies installation from the 1st stage image
COPY --from=builder /root/.local/bin /root/.local/bin
COPY --from=builder /root/.local/lib /root/.local/lib
COPY *.py ./

# Update PATH environment variable
ENV PATH=/root/.local/bin:$PATH

CMD ["gunicorn", "app:create_app()", "--bind", "0.0.0.0:8000", "--access-logfile", "-", "--error-logfile", "-"]
