#!/bin/sh

set -e

echo "Generating nginx.conf..."

envsubst '
$EXPOSED_PORT
$SERVER_NAME_DASHBOARD
$SERVER_NAME_ADMIN_PANEL
$SERVER_NAME_WEB_APP
$SERVER_NAME_AUTH
$SERVER_NAME_HEALTH
$SERVER_NAME_API
$SERVER_NAME_MOBILE_APP
$SERVER_WALLET_STAT
$SERVER_NAME_GRAFANA
$SERVER_NAME_KIBANA
$SERVER_NAME_KC
$SERVER_NAME_V2_AUTH
$SERVER_NAME_BETA_APP
$SERVER_NAME_SWAGGER
$SERVER_NAME_ADMIN_V2_PANEL
' \
< /etc/nginx/nginx.conf.template \
> /etc/nginx/nginx.conf


echo "Generated config size:"
wc -c /etc/nginx/nginx.conf

echo "Checking events section:"
grep "events" /etc/nginx/nginx.conf || true


nginx -t

exec nginx -g "daemon off;"