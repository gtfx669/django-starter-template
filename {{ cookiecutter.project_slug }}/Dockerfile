FROM python:3.12-slim as base

ARG ENVIRONMENT
# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1
RUN apt-get update \
    && apt-get -y install --no-install-recommends libpq-dev build-essential

ENV POETRY_VERSION=1.6.1
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv

# Tell Poetry where to place its cache and virtual environment
ENV POETRY_CACHE_DIR=/opt/.cache

# Creating a virtual environment just for poetry and install it with pip
RUN python3 -m venv $POETRY_VENV \
    && $POETRY_VENV/bin/pip install -U pip setuptools \
    && $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}

# Create a new stage from the base python image
FROM base as base-app

# Copy Poetry to app image
COPY --from=base ${POETRY_VENV} ${POETRY_VENV}

# Add Poetry to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"

RUN useradd --create-home appuser
WORKDIR /home/appuser




FROM base-app as app-prod
COPY poetry.lock pyproject.toml ./
RUN poetry check
RUN poetry install --no-interaction --no-cache --without dev
COPY . .

RUN poetry run gunicorn -c gunicorn.{{ cookiecutter.project_slug }}.py

FROM base-app as app-dev
COPY poetry.lock pyproject.toml ./
RUN poetry check
RUN poetry install --no-interaction --no-cache 
COPY . .

ENTRYPOINT ["/home/appuser/scripts/entrypoint.sh"]
CMD poetry run python manage.py runserver 0.0.0.0:8000