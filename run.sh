#!/bin/sh

#docker build --tag rekgrpth/nginx:debug . || exit $?
#docker push rekgrpth/nginx:debug || exit $?
docker stop nginx
docker rm nginx
docker pull rekgrpth/nginx:debug || exit $?
docker volume create nginx || exit $?
docker network create my
docker run \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env USER_ID=$(id -u) \
    --hostname nginx \
    --link nginx:$(hostname -f) \
    --name nginx \
    --network my \
    --publish 443:443 \
    --publish 80:80 \
    --restart always \
    --volume /etc/certs/$(hostname -d).crt:/etc/nginx/ssl/$(hostname -d).crt \
    --volume /etc/certs/$(hostname -d).key:/etc/nginx/ssl/$(hostname -d).key \
    --volume nginx:/data/nginx \
    $(find /var/lib/docker/volumes -maxdepth 1 -mindepth 1 -type d | while read VOLUME; do
        if test -n "$(docker ps --filter "name=$(basename "$VOLUME")" --filter "status=running" --format "{{.Names}}")"; then
            test -d "$VOLUME/_data/app" && echo "--volume $VOLUME/_data/app:/data/$(basename "$VOLUME")"
            test -d "$VOLUME/_data/log" && echo "--volume $VOLUME/_data/log:/var/log/nginx/$(basename "$VOLUME")"
            test -f "$VOLUME/_data/nginx.conf" && echo "--volume $VOLUME/_data/nginx.conf:/etc/nginx/conf.d/$(basename "$VOLUME").conf"
        fi
    done) \
    --volume /var/lib/docker/volumes/nginx/_data/log:/var/log/nginx/nginx \
    --volume /var/lib/docker/volumes/nginx/_data/module.conf:/etc/nginx/modules/nginx.conf \
    --volume /var/lib/docker/volumes/nginx/_data/nginx.conf:/etc/nginx/conf.d/nginx.conf \
    rekgrpth/nginx:debug
