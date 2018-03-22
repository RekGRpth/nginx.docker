FROM alpine

MAINTAINER RekGRpth

RUN apk add --no-cache \
    nginx \
    shadow \
    tzdata

ENV HOME=/data/nginx \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=nginx \
    GROUP=nginx

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh && usermod --home ${HOME} ${USER}
ENTRYPOINT ["/entrypoint.sh"]

VOLUME  ${HOME}
WORKDIR ${HOME}

CMD [ "nginx" ]
