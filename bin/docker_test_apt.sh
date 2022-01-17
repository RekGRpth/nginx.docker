#!/bin/sh -eux

apt-get update
apt-get full-upgrade -y --no-install-recommends
apt-get install -y --no-install-recommends \
    curl \
    git \
    gosu \
    make \
    perl \
    postgresql \
    valgrind \
;
cpan -Ti \
    Test::Nginx::Socket \
;
service postgresql start
