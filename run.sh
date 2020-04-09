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
    --name nginx \
    --publish target=443,published=443,mode=host \
    --restart always \
    --volume /etc/certs:/etc/certs \
    --volume nginx:/home \
    --volume /run/nginx:/run/nginx \
    --volume /run/postgresql:/run/postgresql \
    --volume /run/uwsgi:/run/uwsgi \
    --volume /var/lib/docker/volumes/nginx/_data/main.conf:/etc/nginx/nginx.conf \
    --network name=docker,alias=$(hostname -f),alias=api-$(hostname -f),alias=cas-$(hostname -f)$(docker volume ls --format "{{.Name}}" | while read VOLUME; do
        echo -n ",alias=$VOLUME-$(hostname -f)"
    done) \
    $(docker volume ls --format "{{.Name}}" | while read VOLUME; do
        echo "--volume $VOLUME:/etc/nginx/$VOLUME"
    done) \
    rekgrpth/nginx
