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
    perl \
    postgresql \
    valgrind \
;
rm -rf /usr/local/man
cpan -Ti \
    Test::File \
    Test::Nginx::Socket \
;
service postgresql start
