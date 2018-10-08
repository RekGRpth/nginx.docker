FROM alpine

MAINTAINER RekGRpth

ADD entrypoint.sh /

ENV GROUP=nginx \
    HOME=/data/nginx \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=nginx

RUN mkdir -p "${HOME}" \
    && addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
    && apk add --no-cache --virtual .build-deps \
        curl-dev \
        gcc \
        git \
        libc-dev \
        linux-headers \
        make \
        pcre-dev \
        postgresql-dev \
        zlib-dev \
    && mkdir -p /usr/src \
    && git clone --progress --recursive https://github.com/RekGRpth/array-var-nginx-module.git /usr/src/array \
    && git clone --progress --recursive https://github.com/RekGRpth/echo-nginx-module.git /usr/src/echo \
    && git clone --progress --recursive https://github.com/RekGRpth/encrypted-session-nginx-module.git /usr/src/session \
    && git clone --progress --recursive https://github.com/RekGRpth/form-input-nginx-module.git /usr/src/form \
    && git clone --progress --recursive https://github.com/RekGRpth/headers-more-nginx-module.git /usr/src/headers \
    && git clone --progress --recursive https://github.com/RekGRpth/iconv-nginx-module.git /usr/src/iconv \
    && git clone --progress --recursive https://github.com/RekGRpth/nchan.git /usr/src/nchan \
    && git clone --progress --recursive https://github.com/RekGRpth/nginx-eval-module.git /usr/src/eval \
    && git clone --progress --recursive https://github.com/RekGRpth/NginxExecute.git /usr/src/exec \
    && git clone --progress --recursive https://github.com/RekGRpth/nginx.git /usr/src/nginx \
    && git clone --progress --recursive https://github.com/RekGRpth/nginx-json-var-module.git /usr/src/var \
    && git clone --progress --recursive https://github.com/RekGRpth/nginx-push-stream-module.git /usr/src/push \
    && git clone --progress --recursive https://github.com/RekGRpth/ngx_devel_kit.git /usr/src/0devel \
    && git clone --progress --recursive https://github.com/RekGRpth/ngx_postgres.git /usr/src/postgres \
    && git clone --progress --recursive https://github.com/RekGRpth/rds-csv-nginx-module.git /usr/src/csv \
    && git clone --progress --recursive https://github.com/RekGRpth/rds-json-nginx-module.git /usr/src/json \
    && git clone --progress --recursive https://github.com/RekGRpth/set-misc-nginx-module.git /usr/src/misc \
    && cd /usr/src/nginx \
    && auto/configure \
        --add-dynamic-module=/usr/src/0devel \
        --add-dynamic-module=/usr/src/array \
        --add-dynamic-module=/usr/src/csv \
        --add-dynamic-module=/usr/src/echo \
        --add-dynamic-module=/usr/src/eval \
        --add-dynamic-module=/usr/src/exec \
        --add-dynamic-module=/usr/src/form \
        --add-dynamic-module=/usr/src/headers \
        --add-dynamic-module=/usr/src/iconv \
        --add-dynamic-module=/usr/src/json \
        --add-dynamic-module=/usr/src/misc \
        --add-dynamic-module=/usr/src/nchan \
        --add-dynamic-module=/usr/src/postgres \
        --add-dynamic-module=/usr/src/push \
        --add-dynamic-module=/usr/src/session \
        --add-dynamic-module=/usr/src/var \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --group="${GROUP}" \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-log-path=/var/log/nginx/access.log \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --lock-path=/var/run/nginx.lock \
        --modules-path=/usr/lib/nginx/modules \
        --pid-path=/var/run/nginx.pid \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --user="${USER}" \
        --with-compat \
        --with-debug \
        --with-file-aio \
        --with-http_gzip_static_module \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-stream \
        --with-stream_ssl_module \
        --with-threads \
    && make -j$(nproc) \
    && make install \
    && rm -rf /etc/nginx/html/ \
    && mkdir /etc/nginx/conf.d/ \
    && mkdir -p /usr/share/nginx/html/ \
    && mkdir -p /var/cache/nginx/ \
    && install -m644 docs/html/index.html /usr/share/nginx/html/ \
    && install -m644 docs/html/50x.html /usr/share/nginx/html/ \
    && ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
    && strip /usr/sbin/nginx* \
    && strip /usr/lib/nginx/modules/*.so \
    && rm -rf /usr/src \
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache --virtual .nginx-rundeps $runDeps \
    && apk del .build-deps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
    && apk add --no-cache shadow tzdata \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && chmod +x /entrypoint.sh \
    && rm -f /etc/nginx/conf.d/*.conf

COPY nginx.conf /etc/nginx/nginx.conf

VOLUME  ${HOME}

WORKDIR ${HOME}

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "nginx" ]
