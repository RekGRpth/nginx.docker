#!/bin/sh

#docker build --tag rekgrpth/nginx . || exit $?
#docker push rekgrpth/nginx || exit $?
docker stop nginx
docker rm nginx
docker pull rekgrpth/nginx || exit $?
docker volume create nginx || exit $?
docker network create my
mkdir -p /var/lib/docker/volumes/nginx/_data/log
touch /var/lib/docker/volumes/nginx/_data/http.conf
touch /var/lib/docker/volumes/nginx/_data/main.conf
touch /var/lib/docker/volumes/nginx/_data/module.conf
touch /var/lib/docker/volumes/nginx/_data/nginx.conf
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
    --volume nginx:/home \
    $(find /var/lib/docker/volumes -maxdepth 1 -mindepth 1 -type d | while read VOLUME; do
        if test -n "$(docker ps --filter "name=$(basename "$VOLUME")" --filter "status=running" --format "{{.Names}}")"; then
            test -d "$VOLUME/_data/app" && echo "--volume $VOLUME/_data/app:/home/$(basename "$VOLUME")"
            test -d "$VOLUME/_data/html" && echo "--volume $VOLUME/_data/html:/etc/nginx/html/$(basename "$VOLUME")"
            test -d "$VOLUME/_data/ctpp" && echo "--volume $VOLUME/_data/ctpp:/etc/nginx/ctpp/$(basename "$VOLUME")"
            test -d "$VOLUME/_data/log" && echo "--volume $VOLUME/_data/log:/var/log/nginx/$(basename "$VOLUME")"
            test -f "$VOLUME/_data/nginx.conf" && echo "--link nginx:$(basename "$VOLUME")-$(hostname -f)"
            test -f "$VOLUME/_data/nginx.conf" && echo "--volume $VOLUME/_data/nginx.conf:/etc/nginx/conf.d/$(basename "$VOLUME").conf"
        fi
    done) \
    --volume /var/lib/docker/volumes/nginx/_data/ctpp:/etc/nginx/ctpp/nginx \
    --volume /var/lib/docker/volumes/nginx/_data/html:/etc/nginx/html/nginx \
    --volume /var/lib/docker/volumes/nginx/_data/http.conf:/etc/nginx/http.conf \
    --volume /var/lib/docker/volumes/nginx/_data/log:/var/log/nginx/nginx \
    --volume /var/lib/docker/volumes/nginx/_data/main.conf:/etc/nginx/nginx.conf \
    --volume /var/lib/docker/volumes/nginx/_data/module.conf:/etc/nginx/module.conf \
    --volume /var/lib/docker/volumes/nginx/_data/nginx.conf:/etc/nginx/conf.d/nginx.conf \
    rekgrpth/nginx
