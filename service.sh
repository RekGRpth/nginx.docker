#!/bin/sh

#docker build --tag rekgrpth/nginx . || exit $?
#docker push rekgrpth/nginx || exit $?
docker pull rekgrpth/nginx || exit $?
docker volume create nginx || exit $?
mkdir -p /var/lib/docker/volumes/nginx/_data/log
touch /var/lib/docker/volumes/nginx/_data/http.conf
touch /var/lib/docker/volumes/nginx/_data/main.conf
touch /var/lib/docker/volumes/nginx/_data/module.conf
docker network create --attachable --driver overlay docker || echo $?
docker service create \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname nginx \
    --mount type=bind,source=/etc/certs,destination=/etc/certs \
    --mount type=bind,source=/var/lib/docker/volumes/nginx/_data,destination=/etc/nginx/nginx \
    --mount type=bind,source=/var/lib/docker/volumes/nginx/_data/main.conf,destination=/etc/nginx/nginx.conf \
    --mount type=volume,source=nginx,destination=/home \
    --name nginx \
    --network name=docker,alias=api-$(hostname -f),alias=django-$(hostname -f),alias=cherry-$(hostname -f),alias=cas-$(hostname -f),alias=web2py-$(hostname -f) \
    --publish target=443,published=443,mode=host \
    --publish target=80,published=80,mode=host \
    $(find /var/lib/docker/volumes -maxdepth 1 -mindepth 1 -type d | while read VOLUME; do
        if test -n "$(docker ps --filter "name=$(basename "$VOLUME")" --filter "status=running" --format "{{.Names}}")"; then
            echo "--mount type=bind,source=$VOLUME/_data,destination=/etc/nginx/$(basename "$VOLUME")"
        fi
    done) \
    rekgrpth/nginx
