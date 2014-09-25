# nginx with static files

FROM debian:jessie
MAINTAINER Stephen Price <steeef@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y -q nginx \
    openssl ca-certificates

RUN rm /etc/nginx/sites-available/*
ADD nginx/www /etc/nginx/sites-available/www
ADD nginx/nginx.conf /etc/nginx/nginx.conf
RUN ln -s /etc/nginx/sites-available/www /etc/nginx/sites-enabled/

ADD source/www /srv/www

EXPOSE 80

WORKDIR /etc/nginx
CMD ["nginx"]
