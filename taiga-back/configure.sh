#!/bin/sh

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
FRONT_SCHEME=${FRONT_SCHEME:-http}
FRONT_DOMAIN=${FRONT_DOMAIN:-localhost}
MEDIA_URL=${MEDIA_URL:-$FRONT_SCHEME://$FRONT_DOMAIN/media/}
STATIC_URL=${STATIC_URL:-$FRONT_SCHEME://$FRONT_DOMAIN/static/}
SECRET_KEY=${SECRET_KEY:-insecurekey}
PUBLIC_REGISTER_ENABLED=${PUBLIC_REGISTER_ENABLED:-True}
EMAIL=${EMAIL:-}
RABBITMQ_HOST=${RABBITMQ_HOST:-localhost}
TLS_ENABLED=${TLS_ENABLED:-False}
SMTP_SERVER=${SMTP_SERVER:-}
EMAIL_USER=${EMAIL_USER:-}
EMAIL_PASSWORD=${EMAIL_PASSWORD:-}
SMTP_PORT=${SMTP_PORT:-25}

# write /home/taiga/taiga-back/settings/local.py
FILE="/home/taiga/taiga-back/settings/local.py"

/bin/cat <<EOM >$FILE
from .common import *

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'taiga',
        'USER': 'taiga',
        'PASSWORD': 'taiga',
        'HOST': '$DB_HOST',
        'PORT': '$DB_PORT',
    }
}

MEDIA_ROOT = '/home/taiga/media'
STATIC_ROOT = '/home/taiga/static'

MEDIA_URL = "$MEDIA_URL"
STATIC_URL = "$STATIC_URL"
SITES["front"]["scheme"] = "$FRONT_SCHEME"
SITES["front"]["domain"] = "$FRONT_DOMAIN"

SECRET_KEY = "$SECRET_KEY"

DEBUG = False
PUBLIC_REGISTER_ENABLED = $PUBLIC_REGISTER_ENABLED

DEFAULT_FROM_EMAIL = "$EMAIL"
SERVER_EMAIL = DEFAULT_FROM_EMAIL

#CELERY_ENABLED = True

EVENTS_PUSH_BACKEND = "taiga.events.backends.rabbitmq.EventsPushBackend"
EVENTS_PUSH_BACKEND_OPTIONS = {"url": "amqp://taiga:taiga@$RABBITMQ_HOST:5672/taiga"}

# EMAIL PROVIDER
EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
EMAIL_USE_TLS = $TLS_ENABLED
EMAIL_HOST = "$SMTP_SERVER"
EMAIL_HOST_USER = "$EMAIL_USER"
EMAIL_HOST_PASSWORD = "$EMAIL_PASSWORD"
EMAIL_PORT = $SMTP_PORT

# Uncomment and populate with proper connection parameters
# for enable github login/singin.
#GITHUB_API_CLIENT_ID = "yourgithubclientid"
#GITHUB_API_CLIENT_SECRET = "yourgithubclientsecret"
EOM


cat > /home/taiga/taiga-back/circus.ini <<EOL
[circus]
check_delay = 5
endpoint = tcp://127.0.0.1:5555
pubsub_endpoint = tcp://127.0.0.1:5556
statsd = true
[watcher:taiga]
working_dir = /home/taiga/taiga-back
cmd = /usr/local/bin/gunicorn
args = -w 3 -t 60 --pythonpath=. -b 0.0.0.0:8000 taiga.wsgi
uid = taiga
numprocesses = 1
autostart = true
send_hup = true
stdout_stream.class = FileStream
stdout_stream.filename = /home/taiga/logs/gunicorn.stdout.log
stdout_stream.max_bytes = 10485760
stdout_stream.backup_count = 4
stderr_stream.class = FileStream
stderr_stream.filename = /home/taiga/logs/gunicorn.stderr.log
stderr_stream.max_bytes = 10485760
stderr_stream.backup_count = 4
[env:taiga]
TERM=rxvt-256color
SHELL=/bin/bash
USER=taiga
LANG=en_US.UTF-8
HOME=/home/taiga
PYTHONPATH=/usr/local/lib/python3.4/site-packages
EOL


