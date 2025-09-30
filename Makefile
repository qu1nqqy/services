SHELL := /bin/bash
COMPOSE := docker compose
EMAIL ?= $(shell grep -E '^EMAIL=' .env | cut -d= -f2)

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

cert-minio:
	$(COMPOSE) up -d nginx
	$(COMPOSE) run --rm certbot certonly \
	  --webroot -w /var/www/certbot \
	  -d $$(grep -E '^MINIO_CONSOLE_DOMAIN=' .env | cut -d= -f2) \
	  --agree-tos -m $(EMAIL) --no-eff-email

cert-s3:
	$(COMPOSE) up -d nginx
	$(COMPOSE) run --rm certbot certonly \
	  --webroot -w /var/www/certbot \
	  -d $$(grep -E '^MINIO_S3_DOMAIN=' .env | cut -d= -f2) \
	  --agree-tos -m $(EMAIL) --no-eff-email

renew:
	$(COMPOSE) run --rm certbot renew
	$(COMPOSE) exec -T nginx nginx -s reload
