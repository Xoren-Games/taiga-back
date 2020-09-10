#!/usr/bin/env bash
set -euo pipefail
# python manage.py migrate
# python manage.py collectstatic --noinput

mkdir /srv/logs
touch /srv/logs/gunicorn.log
touch /srv/logs/access.log
tail -n 0 -f /srv/logs/*.log &

# Start Taiga processes
echo Starting Taiga API...
exec gunicorn taiga.wsgi:application \
    --name taiga_api \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --worker-tmp-dir /dev/shm \
    --log-level=info \
    --log-file=/srv/logs/gunicorn.log \
    --access-logfile=/srv/logs/access.log \
    "$@"
