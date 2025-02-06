FROM postgres
ENV POSTGRES_PASSWORD="change_me"
COPY schema.sql /docker-entrypoint-initdb.d/schema.sql
HEALTHCHECK --interval=1s --timeout=5s --retries=10 CMD pg_isready -h 127.0.0.1
USER postgres
