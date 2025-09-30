FROM postgres:${POSTGRES_VERSION}
# configs
COPY conf/postgresql.conf /etc/postgresql/postgresql.conf
COPY conf/pg_hba.conf     /etc/postgresql/pg_hba.conf
# optional init scripts
COPY init/ /docker-entrypoint-initdb.d/
# healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=10 \
  CMD pg_isready -U ${POSTGRES_USER:-postgres} || exit 1
# use custom config
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf", "-c", "hba_file=/etc/postgresql/pg_hba.conf"]
