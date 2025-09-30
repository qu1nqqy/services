FROM nginx:1.27-alpine

RUN apk add --no-cache bash gettext

# base config
COPY nginx.conf /etc/nginx/nginx.conf
# templates with ${VARS}
COPY templates/ /etc/nginx/templates/
# entrypoint renders templates → conf.d/*.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir -p /var/www/certbot

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx","-g","daemon off;"]
