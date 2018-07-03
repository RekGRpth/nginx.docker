FROM alpine

MAINTAINER RekGRpth

ADD entrypoint.sh /

ENV HOME=/data/nginx \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=nginx \
    GROUP=nginx

RUN apk add --no-cache \
    nginx \
    shadow \
    tzdata

RUN chmod +x /entrypoint.sh \
    && usermod --home "${HOME}" "${USER}" \
    && rm -f /etc/nginx/conf.d/*.conf \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

VOLUME  ${HOME}

WORKDIR ${HOME}

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "nginx" ]
