#!/bin/sh

echo "ns"
poetry run python manage.py flush --no-input
poetry run python manage.py migrate

exec "$@"