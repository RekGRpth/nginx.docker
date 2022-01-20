#!/bin/sh -eux

install -d -m 1775 -o postgres -g postgres /run/postgresql /var/log/postgresql
gosu postgres initdb --auth=trust --data-checksums --pgdata=/var/lib/postgresql/data
gosu postgres pg_ctl -w start --pgdata=/var/lib/postgresql/data
cd "$HOME"
find "$HOME/src/nginx/modules" -type d -name "t" | grep -v "\.git" | sort | while read -r NAME; do
    cd "$(dirname "$NAME")" && prove
done
gosu postgres pg_ctl -m fast -w stop --pgdata=/var/lib/postgresql/data
