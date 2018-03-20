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
    --env USER_ID=$(id -u) \
    --env GROUP_ID=$(id -g) \
    --publish 443:443 \
    --publish 80:80 \
    --name nginx \
    --hostname nginx \
    --volume /etc/certs/t72.crt:/etc/nginx/ssl/t72.crt:ro \
    --volume /etc/certs/t72.key:/etc/nginx/ssl/t72.key:ro \
    --volume nginx:/data/nginx \
    --volume web2py:/data/web2py \
    --volume django:/data/django \
    --volume laravel:/data/laravel \
    --volume portainer:/data/portainer \
    --volume pgadmin:/data/pgadmin \
    rekgrpth/nginx
