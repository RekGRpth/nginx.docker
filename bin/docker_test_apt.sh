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
PG_VERSION="$(pg_lsclusters --no-header | cut -f1 -d ' ')"
cat >"/etc/postgresql/$PG_VERSION/main/pg_hba.conf" <<EOF
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
EOF
cat >>"/var/lib/postgresql/$PG_VERSION/main/postgresql.auto.conf" <<EOF
log_destination = 'stderr'
unix_socket_directories = '/run/postgresql,/tmp'
EOF
service postgresql start
