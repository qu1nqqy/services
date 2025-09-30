server {
  listen 443 ssl http2;
  server_name ${MINIO_CONSOLE_DOMAIN};

  ssl_certificate     /etc/letsencrypt/live/${MINIO_CONSOLE_DOMAIN}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${MINIO_CONSOLE_DOMAIN}/privkey.pem;

  location / {
    proxy_pass http://minio:9001/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
  }
}
