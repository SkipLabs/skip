FROM python:3.10.16-bookworm
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
RUN pip install uwsgi
RUN adduser --system --no-create-home uwsgi
USER uwsgi
COPY . .
EXPOSE 3031
HEALTHCHECK --interval=30s --timeout=1s --retries=10 CMD curl http://localhost:3031/healthcheck
CMD ["uwsgi", "app.ini"]