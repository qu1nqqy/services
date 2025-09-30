server {
  listen 80;
  server_name ${MINIO_CONSOLE_DOMAIN} ${MINIO_S3_DOMAIN};

  location /.well-known/acme-challenge/ {
    root /var/www/certbot;
  }

  location / {
    return 301 https://$host$request_uri;
  }
}
