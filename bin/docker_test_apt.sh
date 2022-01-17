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
#ln -fs /dev/stdout "/var/log/postgresql/postgresql-$PG_VERSION-main.log"
#ln -fs /dev/stderr "/var/log/postgresql/postgresql-$PG_VERSION-main.log"
PGDATA="/var/lib/postgresql/$PG_VERSION/main"
cat >>"$PGDATA/pg_hba.conf" <<EOF
host all all samenet trust
host replication all samenet trust
EOF
cat >>"$PGDATA/postgresql.auto.conf" <<EOF
log_destination = 'stderr'
unix_socket_directories = '/run/postgresql,/tmp'
EOF
service postgresql start
