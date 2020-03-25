#!/bin/sh

#docker build --tag rekgrpth/nginx . || exit $?
#docker push rekgrpth/nginx || exit $?
docker pull rekgrpth/nginx || exit $?
docker volume create nginx || exit $?
docker network create --attachable --driver overlay docker || echo $?
mkdir -p /var/lib/docker/volumes/nginx/_data/log
touch /var/lib/docker/volumes/nginx/_data/http.conf
touch /var/lib/docker/volumes/nginx/_data/main.conf
touch /var/lib/docker/volumes/nginx/_data/module.conf
docker service create \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname nginx \
    --mount type=bind,source=/etc/certs,destination=/etc/certs \
    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
    --mount type=bind,source=/var/lib/docker/volumes/nginx/_data/main.conf,destination=/etc/nginx/nginx.conf \
    --mount type=volume,source=nginx,destination=/home \
    --name nginx \
    --publish target=443,published=443,mode=host \
    --network name=docker,alias=$(hostname -f),alias=api-$(hostname -f),alias=cas-$(hostname -f)$(find /var/lib/docker/volumes -maxdepth 1 -mindepth 1 -type d | while read VOLUME; do
        echo -n ",alias=$(basename "$VOLUME")-$(hostname -f)"
    done) \
    $(find /var/lib/docker/volumes -maxdepth 1 -mindepth 1 -type d | while read VOLUME; do
        echo "--mount type=bind,source=$VOLUME/_data,destination=/etc/nginx/$(basename "$VOLUME")"
    done) \
    rekgrpth/nginx
