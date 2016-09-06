FROM alpine:3.3
MAINTAINER Stephen Price <steeef@gmail.com>

LABEL caddy_version="0.9.1" architecture="amd64"
ENV HUGO_VERSION=0.16
ENV CADDY_FEATURES=git
ENV DEPENDENCIES git ca-certificates openssh-client
ENV BUILD_PACKAGES wget tar

RUN apk add --no-cache ${DEPENDENCIES} ${BUILD_PACKAGES} && \
  mkdir -p hugo_${HUGO_VERSION} && \
  curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-64bit.tgz" \
    | tar --no-same-owner -C hugo_${HUGO_VERSION} -xz && \
  mv hugo_${HUGO_VERSION}/hugo /usr/bin/hugo && \
  chmod 0755 /usr/bin/hugo && \
  rm -rf hugo_${HUGO_VERSION} && \
  curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64&features=${CADDY_FEATURES}" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy && \
  chmod 0755 /usr/bin/caddy && \
  /usr/bin/caddy -version && \
  apk del ${BUILD_PACKAGES}

EXPOSE 80 443 2015
VOLUME /srv
WORKDIR /srv

ADD Caddyfile /etc/Caddyfile
ADD www/ /srv/

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
