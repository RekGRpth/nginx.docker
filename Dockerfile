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

RUN chmod +x /entrypoint.sh \
    && usermod --home "${HOME}" "${USER}" \
    && rm -f /etc/nginx/conf.d/*.conf \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

ENTRYPOINT ["/entrypoint.sh"]

VOLUME  ${HOME}
WORKDIR ${HOME}

CMD [ "nginx" ]
