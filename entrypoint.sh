#!/bin/sh

if [ "$GROUP_ID" = "" ]; then GROUP_ID=$(id -g "$GROUP"); fi
if [ "$GROUP_ID" != "$(id -g "$GROUP")" ]; then
    find / -group "$GROUP" -exec chgrp "$GROUP_ID" {} \;
    groupmod --gid "$GROUP_ID" "$GROUP"
fi

if [ "$USER_ID" = "" ]; then USER_ID=$(id -u "$USER"); fi
if [ "$USER_ID" != "$(id -u "$USER")" ]; then
    find / -user "$USER" -exec chown "$USER_ID" {} \;
    usermod --uid "$USER_ID" "$USER"
fi

#sed -i "/^\tinclude \/etc\/nginx\/conf\.d\/\*\.conf/cinclude \/data\/\*\/nginx\.conf;" "/etc/nginx/nginx.conf"
#sed -i "/^\taccess_log/caccess_log \/data\/nginx\/log\/access\.log main;" "/etc/nginx/nginx.conf"
#sed -i "/^error_log/cerror_log \/data\/nginx\/log\/error\.log warn;" "/etc/nginx/nginx.conf"
sed -i "/^worker_processes/cworker_processes 4;" "/etc/nginx/nginx.conf"

mkdir -p /run/nginx

find "$HOME" ! -group "$GROUP" -exec chgrp "$GROUP_ID" {} \;
find "$HOME" ! -user "$USER" -exec chown "$USER_ID" {} \;

exec "$@"
