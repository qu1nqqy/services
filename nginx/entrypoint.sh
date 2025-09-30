#!/usr/bin/env bash
set -e

# Render templates using envsubst
for tpl in /etc/nginx/templates/*.tpl; do
  out="/etc/nginx/conf.d/$(basename "${tpl%.*}").conf"
  envsubst '${MINIO_CONSOLE_DOMAIN} ${MINIO_S3_DOMAIN}' < "$tpl" > "$out"
done

exec "$@"
