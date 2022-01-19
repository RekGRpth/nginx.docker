#!/bin/sh -eux

apk add --no-cache --virtual .build-deps \
    curl \
    git \
    libbsd-dev \
    perl-lwp-protocol-https \
    perl-test-nginx \
    perl-utils \
    postgresql \
    valgrind \
;
apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --virtual .edge-deps \
    perl-test-file \
;
install -d -m 1775 -o postgres -g postgres /run/postgresql /var/log/postgresql
gosu postgres pg_ctl initdb --pgdata=/var/lib/postgresql/data
gosu postgres pg_ctl start --pgdata=/var/lib/postgresql/data
