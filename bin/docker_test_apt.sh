#!/bin/sh -eux

apt-get update
apt-get full-upgrade -y --no-install-recommends
apt-get install -y --no-install-recommends \
    curl \
    git \
    gosu \
    perl \
    postgresql \
    valgrind \
;
service postgresql start
