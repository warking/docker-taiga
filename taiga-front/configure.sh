#!/bin/sh

TAIGA_BACK_HOST=${TAIGA_BACK_HOST:-}
TAIGA_EVENT_HOST=${TAIGA_EVENT_HOST:-}
TAIGA_BACK_PUBLIC_HOST=${TAIGA_BACK_PUBLIC_HOST:-}
TAIGA_EVENT_PUBLIC_HOST=${TAIGA_EVENT_PUBLIC_HOST:-}


FILE="/home/taiga/taiga-front/dist/conf.json"

/bin/cat <<EOM >$FILE
{
    "api": "$TAIGA_BACK_PUBLIC_HOST/api/v1/",
    "eventsUrl": "$TAIGA_EVENT_PUBLIC_HOST/events",
    "eventsMaxMissedHeartbeats": 5,
    "eventsHeartbeatIntervalTime": 60000,
    "eventsReconnectTryInterval": 10000,
    "debug": false,
    "debugInfo": false,
    "defaultLanguage": "en",
    "themes": ["taiga"],
    "defaultTheme": "taiga",
    "publicRegisterEnabled": true,
    "feedbackEnabled": true,
    "supportUrl": "https://tree.taiga.io/support",
    "privacyPolicyUrl": null,
    "termsOfServiceUrl": null,
    "GDPRUrl": null,
    "maxUploadFileSize": null,
    "contribPlugins": [],
    "tribeHost": null,
    "importers": [],
    "gravatar": true,
    "rtlLanguages": ["fa"]
}
EOM


cat > /etc/nginx/conf.d/taiga.conf <<EOL
server {
    listen 80 default_server;
    server_name _;

    large_client_header_buffers 4 32k;
    client_max_body_size 50M;
    charset utf-8;

    access_log /home/taiga/logs/nginx.access.log;
    error_log /home/taiga/logs/nginx.error.log;

    # Frontend
    location / {
        root /home/taiga/taiga-front/dist/;
        try_files \$uri \$uri/ /index.html;
    }

    # Backend
    location /api {
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Scheme \$scheme;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_pass http://$TAIGA_BACK_HOST:8000/api;
        proxy_redirect off;
    }

    # Django admin access (/admin/)
    location /admin {
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Scheme \$scheme;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_pass http://$TAIGA_BACK_HOST:8000\$request_uri;
        proxy_redirect off;
    }

    # Static files
    location /static {
        alias /home/taiga/static;
    }

    # Media files
    location /media {
        alias /home/taiga/media;
    }

	# Taiga-events
	location /events {
		proxy_pass http://$TAIGA_EVENT_HOST:8888/events;
		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_connect_timeout 7d;
		proxy_send_timeout 7d;
		proxy_read_timeout 7d;
	}
}
EOL


