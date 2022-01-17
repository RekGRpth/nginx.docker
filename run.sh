#!/bin/sh -eux

docker pull "ghcr.io/rekgrpth/nginx.docker:${INPUTS_BRANCH:-latest}"
docker network create --attachable --opt com.docker.network.bridge.name=docker docker || echo $?
docker volume create nginx
mkdir -p /var/lib/docker/volumes/nginx/_data/log
touch /var/lib/docker/volumes/nginx/_data/http.conf
touch /var/lib/docker/volumes/nginx/_data/main.conf
touch /var/lib/docker/volumes/nginx/_data/module.conf
docker stop nginx || echo $?
docker rm nginx || echo $?
docker run \
    --detach \
    --env GROUP_ID="$(id -g)" \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID="$(id -u)" \
    --hostname nginx \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=bind,source=/run/nginx,destination=/run/nginx \
    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
    --mount type=bind,source=/run/uwsgi,destination=/run/uwsgi \
    --mount type=bind,source=/var/lib/docker/volumes/nginx/_data/main.conf,destination=/etc/nginx/nginx.conf,readonly \
    --mount type=bind,source=/var/log/nginx,destination=/var/log/nginx \
    --mount type=volume,source=nginx,destination=/var/cache/nginx \
    --name nginx \
    --publish target=443,published=443,mode=host \
    --restart always \
    --network name=docker,alias=$(hostname -f),alias=libreoffice."$(hostname -d)",alias=api-$(hostname -f),alias=cas-$(hostname -f)$(docker volume ls --format "{{.Name}}" | while read VOLUME; do
        echo -n ",alias=$VOLUME-$(hostname -f)"
    done) \
    $(docker volume ls --format "{{.Name}}" | while read VOLUME; do
        echo "--mount type=volume,source=$VOLUME,destination=/etc/nginx/$VOLUME,readonly"
    done) \
    "ghcr.io/rekgrpth/nginx.docker:${INPUTS_BRANCH:-latest}"
