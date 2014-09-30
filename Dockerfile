# static web files

FROM busybox
MAINTAINER Stephen Price <steeef@gmail.com>

ADD www /srv/
VOLUME ["/srv/www"]

CMD ["/bin/sh"]
