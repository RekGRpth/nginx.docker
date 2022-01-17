#!/bin/sh -eux

cd /
install -d -m 1775 -o postgres -g postgres /run/postgresql /var/log/postgresql
gosu postgres pg_ctl initdb --pgdata=/var/lib/postgresql/data
gosu postgres pg_ctl start --pgdata=/var/lib/postgresql/data
#docker_build.sh
#cd "$HOME/src/nginx-tests" && prove .
cd "$HOME"
find "$HOME/src/nginx/modules" -type d -name "t" | grep -v "\.git" | sort | while read -r NAME; do
    cd "$(dirname "$NAME")" && prove
done
