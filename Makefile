SHELL := /bin/bash
COMPOSE := docker compose

ENV_FILE := .env
EMAIL := $(shell awk -F= '/^EMAIL=/{print $$2}' $(ENV_FILE))
MINIO_CONSOLE_DOMAIN := $(shell awk -F= '/^MINIO_CONSOLE_DOMAIN=/{print $$2}' $(ENV_FILE))
MINIO_S3_DOMAIN := $(shell awk -F= '/^MINIO_S3_DOMAIN=/{print $$2}' $(ENV_FILE))

.PHONY: up down ps logs nginx reload cert cert-minio cert-s3 renew prune check-env

check-env:
	@test -f $(ENV_FILE) || (echo "❌ $(ENV_FILE) not found"; exit 1)
	@test -n "$(EMAIL)" || (echo "❌ EMAIL is empty in $(ENV_FILE)"; exit 1)
	@test -n "$(MINIO_CONSOLE_DOMAIN)" || (echo "❌ MINIO_CONSOLE_DOMAIN is empty"; exit 1)
	@test -n "$(MINIO_S3_DOMAIN)" || (echo "❌ MINIO_S3_DOMAIN is empty"; exit 1)

up: check-env
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f --tail=200

nginx:
	$(COMPOSE) up -d nginx

reload:
	$(COMPOSE) exec -T nginx nginx -s reload

cert: cert-minio cert-s3

cert-minio: check-env nginx
	$(COMPOSE) run --rm certbot certonly \
	  --webroot -w /var/www/certbot \
	  -d $(MINIO_CONSOLE_DOMAIN) \
	  --agree-tos -m $(EMAIL) --no-eff-email

cert-s3: check-env nginx
	$(COMPOSE) run --rm certbot certonly \
	  --webroot -w /var/www/certbot \
	  -d $(MINIO_S3_DOMAIN) \
	  --agree-tos -m $(EMAIL) --no-eff-email

renew: check-env
	$(COMPOSE) run --rm certbot renew
	$(COMPOSE) exec -T nginx nginx -s reload

# безопасная очистка (не трогаем volumes с данными БД/MinIO)
prune:
	docker system prune -a -f
