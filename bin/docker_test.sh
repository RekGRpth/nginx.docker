#!/bin/sh -eux

install -d -m 1775 -o postgres -g postgres /run/postgresql /var/log/postgresql
INITDB="$(which initdb)"
PG_CTL="$(which pg_ctl)"
gosu postgres "$INITDB" --auth=trust --pgdata=/var/lib/postgresql/data
gosu postgres "$PG_CTL" -w start --pgdata=/var/lib/postgresql/data
cd "$HOME"
find "$HOME/src/nginx/modules" -type d -name "t" | grep -v "\.git" | sort | while read -r NAME; do
    cd "$(dirname "$NAME")" && prove
done
gosu postgres "$PG_CTL" -m fast -w stop --pgdata=/var/lib/postgresql/data
