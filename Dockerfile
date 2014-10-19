FROM busybox
MAINTAINER Stephen Price <steeef@gmail.com>

ADD www /srv/www
VOLUME ["/srv/www"]

CMD ["/bin/sh"]
