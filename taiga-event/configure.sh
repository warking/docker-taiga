#!/bin/sh


SECRET_KEY=${SECRET_KEY:-insecurekey}
RABBITMQ_HOST=${RABBITMQ_HOST:-localhost}

# write /home/taiga/taiga-back/settings/local.py
FILE="/home/taiga/taiga-events/config.json"

/bin/cat <<EOM >$FILE
{
    "url": "amqp://taiga:taiga@$RABBITMQ_HOST:5672/taiga",
    "secret": "$SECRET_KEY",
    "webSocketServer": {
        "port": 8888
    }
}
EOM


cat > /home/taiga/taiga-events/circus.ini <<EOL
[circus]
check_delay = 5
endpoint = tcp://127.0.0.1:5555
pubsub_endpoint = tcp://127.0.0.1:5556
statsd = true
[watcher:taiga-events]
working_dir = /home/taiga/taiga-events
cmd = /usr/bin/coffee
args = index.coffee
uid = taiga
numprocesses = 1
autostart = true
send_hup = true
stdout_stream.class = FileStream
stdout_stream.filename = /home/taiga/logs/taigaevents.stdout.log
stdout_stream.max_bytes = 10485760
stdout_stream.backup_count = 12
stderr_stream.class = FileStream
stderr_stream.filename = /home/taiga/logs/taigaevents.stderr.log
stderr_stream.max_bytes = 10485760
stderr_stream.backup_count = 12
[env:taiga]
TERM=rxvt-256color
SHELL=/bin/bash
USER=taiga
LANG=en_US.UTF-8
HOME=/home/taiga
PYTHONPATH=/usr/local/lib/python3.4/site-packages
EOL


