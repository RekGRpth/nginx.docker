#!/bin/sh

#docker build --tag rekgrpth/nginx . || exit $?
#docker push rekgrpth/nginx || exit $?
docker stop nginx
docker rm nginx
docker pull rekgrpth/nginx || exit $?
docker volume create nginx || exit $?
docker network create --opt com.docker.network.bridge.name=docker docker
mkdir -p /var/lib/docker/volumes/nginx/_data/log
touch /var/lib/docker/volumes/nginx/_data/http.conf
touch /var/lib/docker/volumes/nginx/_data/main.conf
touch /var/lib/docker/volumes/nginx/_data/module.conf
docker run \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname nginx \
    --link nginx:$(hostname -f) \
    --name nginx \
    --network docker \
    --publish 443:443 \
    --publish 80:80 \
    --restart always \
    --volume /etc/certs/$(hostname -d).crt:/etc/nginx/ssl/$(hostname -d).crt \
    --volume /etc/certs/$(hostname -d).key:/etc/nginx/ssl/$(hostname -d).key \
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
