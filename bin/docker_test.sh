#!/bin/sh -eux

install -d -m 1775 -o postgres -g postgres /run/postgresql /var/log/postgresql
DOCKER_TYPE="$(cat /etc/os-release | grep -E '^ID=' | cut -f2 -d '=')"
if [ $DOCKER_TYPE != "alpine" ]; then
    POSTGRES_VERSION="$(pg_lsclusters --no-header | cut -f1 -d ' ')"
    export PATH="$PATH:/usr/lib/postgresql/$POSTGRES_VERSION/bin"
fi
gosu postgres initdb --auth=trust --pgdata=/var/lib/postgresql/data
gosu postgres pg_ctl -w start --pgdata=/var/lib/postgresql/data
cd "$HOME"
find "$HOME/src/nginx/modules" -type d -name "t" | grep -v "\.git" | sort | while read -r NAME; do
    cd "$(dirname "$NAME")" && prove
done
gosu postgres pg_ctl -m fast -w stop --pgdata=/var/lib/postgresql/data
