#!/bin/sh -x

#docker build --tag rekgrpth/nginx . || exit $?
#docker push rekgrpth/nginx || exit $?
docker pull rekgrpth/nginx || exit $?
docker volume create nginx || echo $?
docker network create --attachable --driver overlay docker || echo $?
mkdir -p /var/lib/docker/volumes/nginx/_data/log || exit $?
touch /var/lib/docker/volumes/nginx/_data/http.conf || exit $?
touch /var/lib/docker/volumes/nginx/_data/main.conf || exit $?
touch /var/lib/docker/volumes/nginx/_data/module.conf || exit $?
docker service rm nginx || echo $?
docker service create \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname="{{.Service.Name}}-{{.Node.Hostname}}" \
    --mode global \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=bind,source=/run/nginx,destination=/run/nginx \
    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
    --mount type=bind,source=/run/uwsgi,destination=/run/uwsgi \
    --mount type=bind,source=/var/lib/docker/volumes/nginx/_data/main.conf,destination=/etc/nginx/nginx.conf,readonly \
    --mount type=bind,source=/var/log/nginx,destination=/var/log/nginx \
    --mount type=volume,source=nginx,destination=/home \
    --name nginx \
    --publish target=443,published=443,mode=host \
    --network name=docker,alias=$(hostname -f),alias=api-$(hostname -f),alias=cas-$(hostname -f)$(docker volume ls --format "{{.Name}}" | while read VOLUME; do
        echo -n ",alias=$VOLUME-$(hostname -f)"
    done) \
    $(docker volume ls --format "{{.Name}}" | while read VOLUME; do
        echo "--mount type=volume,source=$VOLUME,destination=/etc/nginx/$VOLUME,readonly"
    done) \
    rekgrpth/nginx
