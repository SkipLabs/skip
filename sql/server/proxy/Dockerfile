# we use x86-64 in the cloud
FROM --platform=linux/amd64 nginx

RUN rm /etc/nginx/nginx.conf /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx
