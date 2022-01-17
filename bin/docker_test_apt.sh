#!/bin/sh -eux

apt-get update
apt-get full-upgrade -y --no-install-recommends
apt-get install -y --no-install-recommends \
    curl \
    gcc \
    git \
    gosu \
    libc-dev \
    libperl-dev \
    make \
    man-db \
    perl \
    postgresql \
    valgrind \
;
cpan -Ti \
    Test::File \
    Test::Nginx::Socket \
;
service postgresql start
