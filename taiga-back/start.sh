#!/bin/sh

cd /home/taiga/taiga-back

python manage.py migrate --noinput
python manage.py compilemessages
python manage.py collectstatic --noinput

DB_PORT=${DB_PORT:-5432}

echo "Waiting for Postgresql to be available..."
while ! nc -z ${DB_HOST} ${DB_PORT}; do
  sleep 1
done

chown -R taiga /home/taiga/

/usr/local/bin/circusd /home/taiga/taiga-back/circus.ini
