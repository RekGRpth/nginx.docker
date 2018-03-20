FROM alpine

MAINTAINER RekGRpth

RUN apk add --no-cache \
    nginx \
    shadow \
    su-exec \
    tzdata

ENV HOME /data/nginx
ENV LANG ru_RU.UTF-8
ENV TZ=Asia/Yekaterinburg

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

VOLUME /data/nginx
WORKDIR /data/nginx

#CMD ["nginx", "-g", "daemon off;"]
CMD [ "nginx" ]
