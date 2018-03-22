#!/bin/sh

#docker build --tag rekgrpth/nginx . && \
#docker push rekgrpth/nginx && \
docker stop nginx
docker rm nginx
docker pull rekgrpth/nginx && \
docker volume create nginx && \
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env USER_ID=$(id -u) \
    --hostname nginx \
    --name nginx \
    --publish 443:443 \
    --publish 80:80 \
    --volume /etc/certs/t72.crt:/etc/nginx/ssl/t72.crt:ro \
    --volume /etc/certs/t72.key:/etc/nginx/ssl/t72.key:ro \
    --volume nginx:/data/nginx \
    $(find /var/lib/docker/volumes -maxdepth 1 -mindepth 1 -type d | while read VOLUME; do
        test -f "$VOLUME/_data/nginx.conf" && echo "--volume $VOLUME/_data/nginx.conf:/etc/nginx/conf.d/$(basename "$VOLUME").conf:ro"
        test -d "$VOLUME/_data/app" && echo "--volume $VOLUME/_data/app:/data/$(basename "$VOLUME"):ro"
        test -d "$VOLUME/_data/log" && echo "--volume $VOLUME/_data/log:/var/log/nginx/$(basename "$VOLUME")"
    done) \
    rekgrpth/nginx
