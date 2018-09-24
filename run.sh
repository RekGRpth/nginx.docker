#!/bin/sh

#docker build --tag rekgrpth/nginx . || exit $?
#docker push rekgrpth/nginx || exit $?
docker stop nginx
docker rm nginx
docker pull rekgrpth/nginx || exit $?
docker volume create nginx || exit $?
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host web2py-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host api-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env USER_ID=$(id -u) \
    --hostname nginx \
    $(docker ps --format "{{.Names}}" | while read -r NAME; do echo "--link $NAME"; done) \
    --name nginx \
    --publish 443:443 \
    --publish 80:80 \
    --restart always \
    --volume /etc/certs/`hostname -d`.crt:/etc/nginx/ssl/`hostname -d`.crt:ro \
    --volume /etc/certs/`hostname -d`.key:/etc/nginx/ssl/`hostname -d`.key:ro \
    --volume nginx:/data/nginx \
    $(find /var/lib/docker/volumes -maxdepth 1 -mindepth 1 -type d | while read VOLUME; do
        if test -n "$(docker ps --filter "name=$(basename "$VOLUME")" --filter "status=running" --format "{{.Names}}")"; then
            test -f "$VOLUME/_data/nginx.conf" && echo "--volume $VOLUME/_data/nginx.conf:/etc/nginx/conf.d/$(basename "$VOLUME").conf:ro"
            test -d "$VOLUME/_data/app" && echo "--volume $VOLUME/_data/app:/data/$(basename "$VOLUME"):ro"
            test -d "$VOLUME/_data/log" && echo "--volume $VOLUME/_data/log:/var/log/nginx/$(basename "$VOLUME")"
        fi
    done) \
    --volume /var/lib/docker/volumes/nginx/_data/module.conf:/etc/nginx/modules/nginx.conf:ro \
    --volume /var/lib/docker/volumes/nginx/_data/nginx.conf:/etc/nginx/conf.d/nginx.conf:ro \
    --volume /var/lib/docker/volumes/nginx/_data/log:/var/log/nginx/nginx \
    rekgrpth/nginx
