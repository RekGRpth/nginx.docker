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
    --volume django:/data/django \
    --volume laravel:/data/laravel \
    --volume nginx:/data/nginx \
    --volume pgadmin:/data/pgadmin \
    --volume portainer:/data/portainer \
    --volume prest:/data/prest \
    --volume web2py:/data/web2py \
    rekgrpth/nginx
