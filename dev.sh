#!/bin/sh

#docker build --tag rekgrpth/nginx . || exit $?
#docker push rekgrpth/nginx || exit $?
docker pull rekgrpth/nginx || exit $?
docker volume create nginx || exit $?
docker network create --attachable --opt com.docker.network.bridge.name=docker docker || echo $?
mkdir -p /var/lib/docker/volumes/nginx/_data/log
touch /var/lib/docker/volumes/nginx/_data/http.conf
touch /var/lib/docker/volumes/nginx/_data/main.conf
touch /var/lib/docker/volumes/nginx/_data/module.conf
docker stop nginx || echo $?
docker rm nginx || echo $?
docker run \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname nginx \
    --link nginx:$(hostname -f) \
    --name nginx \
    --network name=docker,alias=api-$(hostname -f),alias=django-$(hostname -f),alias=cherry-$(hostname -f),alias=cas-$(hostname -f),alias=web2py-$(hostname -f) \
    --publish target=443,published=443,mode=host \
    --publish target=80,published=80,mode=host \
    --restart always \
    --volume /etc/certs:/etc/certs \
    --volume nginx:/home \
    --volume /var/lib/docker/volumes/nginx/_data:/etc/nginx/nginx \
    --volume /var/lib/docker/volumes/nginx/_data/main.conf:/etc/nginx/nginx.conf \
    $(find /var/lib/docker/volumes -maxdepth 1 -mindepth 1 -type d | while read VOLUME; do
        if test -n "$(docker ps --filter "name=$(basename "$VOLUME")" --filter "status=running" --format "{{.Names}}")"; then
            echo "--link nginx:$(basename "$VOLUME")-$(hostname -f)"
            echo "--volume $VOLUME/_data:/etc/nginx/$(basename "$VOLUME")"
        fi
    done) \
    rekgrpth/nginx
