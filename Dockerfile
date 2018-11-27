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
        cmake \
        g++ \
        gcc \
        gd-dev \
        gettext-dev \
        git \
        jansson-dev \
        krb5-dev \
        libc-dev \
        linux-headers \
        linux-pam-dev \
        make \
        openldap-dev \
        pcre-dev \
        postgresql-dev \
        zlib-dev \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone --recursive https://github.com/RekGRpth/array-var-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/ctpp2.git \
    && git clone --recursive https://github.com/RekGRpth/echo-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/encrypted-session-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/form-input-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/headers-more-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/iconv-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/libjwt.git \
#    && git clone --recursive https://github.com/RekGRpth/nchan.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-auth-ldap.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-client-module.git \
    && git clone --recursive https://github.com/RekGRpth/nginx_csrf_prevent.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-eval-module.git \
    && git clone --recursive https://github.com/RekGRpth/NginxExecute.git \
    && git clone --recursive https://github.com/RekGRpth/nginx.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-http-auth-digest.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-json-var-module.git \
#    && git clone --recursive https://github.com/RekGRpth/nginx-jwt-module.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-push-stream-module.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-toolkit-module.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-upload-module.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-uuid4-module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_ctpp2.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_devel_kit.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_auth_jwt_module.git \
#    && git clone --recursive https://github.com/RekGRpth/ngx-http-auth-jwt-module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_auth_pam_module.git \
#    && git clone --recursive https://github.com/RekGRpth/ngx_http_captcha.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_captcha_module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_kerberos_module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_postgres.git \
    && git clone --recursive https://github.com/RekGRpth/rds-csv-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/rds-json-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/set-misc-nginx-module.git \
    && cd /usr/src/libjwt \
    && cmake . -DBUILD_SHARED_LIBS=true && make -j$(nproc) && make install \
    && cd /usr/src/ctpp2 \
    && cmake . -DCMAKE_INSTALL_PREFIX=/usr/local && make -j$(nproc) && make install \
    && cd /usr/src/nginx \
    && auto/configure \
        --add-dynamic-module=../ngx_devel_kit \
        --add-dynamic-module=../nginx-toolkit-module \
        $(find .. -maxdepth 1 -mindepth 1 -type d ! -name "nginx" ! -name "ctpp2" ! -name "ngx_devel_kit" ! -name "nginx-toolkit-module" ! -name "libjwt" | while read -r NAME; do echo "--add-dynamic-module=$NAME"; done) \
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
        --modules-path=/etc/nginx/modules \
        --pid-path=/var/run/nginx.pid \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --user="${USER}" \
        --with-compat \
        --with-debug \
        --with-file-aio \
        --with-http_auth_request_module \
        --with-http_gzip_static_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_ssl_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-stream \
        --with-stream_ssl_module \
        --with-threads \
    && make -j$(nproc) \
    && make install \
    && rm -rf /etc/nginx/html \
    && mkdir -p /etc/nginx/conf.d/ \
    && mkdir -p /usr/share/nginx/html/ \
    && mkdir -p /var/cache/nginx/ \
    && ln -sf "${HOME}"/html /etc/nginx/html \
    && strip /usr/sbin/nginx* \
    && strip /etc/nginx/modules/*.so \
    && rm -rf /usr/src \
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /etc/nginx/modules/*.so /usr/local/lib/*.so /tmp/envsubst \
            | tr ',' '\n' \
            | sort -u \
            | grep -v libctpp2 \
            | grep -v libjwt \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache --virtual .nginx-rundeps $runDeps \
    && apk del .build-deps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
    && apk add --no-cache apache2-utils shadow ttf-liberation tzdata \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && chmod +x /entrypoint.sh \
    && rm -f /etc/nginx/conf.d/*.conf

COPY nginx.conf /etc/nginx/nginx.conf

VOLUME  ${HOME}

WORKDIR ${HOME}

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "nginx" ]
