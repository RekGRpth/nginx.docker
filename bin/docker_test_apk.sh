#!/bin/sh -eux

#docker_build_apk.sh
apk add --no-cache --virtual .build-deps \
    curl \
    git \
    libbsd-dev \
    perl-lwp-protocol-https \
    perl-test-nginx \
    perl-utils \
    postgresql \
    su-exec \
    valgrind \
;
apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --virtual .edge-deps \
    perl-test-file \
;
