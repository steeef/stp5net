FROM alpine:3.4
MAINTAINER Stephen Price <steeef@gmail.com>

LABEL caddy_version="0.9.3" architecture="amd64"
ENV HUGO_VERSION=0.17
ARG features=git,cloudflare
ENV DEPENDENCIES curl git ca-certificates openssh-client libcap
ENV BUILD_PACKAGES tar
ENV CADDY_UID=1001
ENV CADDY_GID=1001

RUN apk add --no-cache ${DEPENDENCIES} ${BUILD_PACKAGES}


RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" \
    | tar --no-same-owner -xz && \
  mv hugo_${HUGO_VERSION}_linux_amd64/hugo_${HUGO_VERSION}_linux_amd64 /usr/bin/hugo && \
  chmod 0755 /usr/bin/hugo && \
  rm -rf hugo_${HUGO_VERSION}_linux_amd64

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64&features=${features}" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy && \
  chmod 0755 /usr/bin/caddy && \
  addgroup -S -g ${CADDY_GID} caddy && \
  adduser -D -S -s /sbin/nologin -G caddy -u ${CADDY_UID} caddy && \
  setcap cap_net_bind_service=+ep /usr/bin/caddy && \
  /usr/bin/caddy -version

RUN apk del ${BUILD_PACKAGES}

EXPOSE 80 443 2015
WORKDIR /srv

ADD Caddyfile /etc/Caddyfile
ADD www/ /srv/

RUN chown -R caddy:caddy /srv

USER caddy

RUN ulimit -n 4096

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
