#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

source ./.env

PYTHON=$(command -v python3)

sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \[\'$ALLOWED_HOSTS\'\]/g" lib_catalog/settings.py

if [ "$($PYTHON manage.py createsuperuser --email="$DJANGO_SUPERUSER_EMAIL" --noinput)" ]; then
  "$PYTHON" manage.py migrate
  "$PYTHON" manage.py loaddata catalog/fixtures/bbk_data.json
  if [ "$($PYTHON manage.py createsuperuser --email="$DJANGO_SUPERUSER_EMAIL" --noinput)" ]; then
    "$PYTHON" manage.py runserver 0.0.0.0:8000
  else
    "$PYTHON" manage.py runserver 0.0.0.0:8000
  fi
else
  "$PYTHON" manage.py runserver 0.0.0.0:8000
fi
