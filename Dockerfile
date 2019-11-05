FROM rekgrpth/pdf
CMD [ "nginx" ]
COPY NimbusSans-Regular.ttf /usr/local/share/fonts/
ENV GROUP=nginx \
    USER=nginx
VOLUME "${HOME}"
RUN set -ex \
    && mkdir -p "${HOME}" \
    && addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
    && apk add --no-cache --virtual .build-deps \
        bison \
        cmake \
        expat-dev \
        expect-dev \
        ffcall \
        g++ \
        gcc \
        gd-dev \
        gettext-dev \
        git \
        jansson-dev \
        jpeg-dev \
        libc-dev \
        libunwind-dev \
        linux-headers \
        make \
        openjpeg-dev \
        openldap-dev \
        pcre-dev \
        perl-dev \
        postgresql-dev \
        readline-dev \
        sqlite-dev \
        zlib-dev \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone --recursive https://github.com/RekGRpth/array-var-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/ctpp2.git \
    && git clone --recursive https://github.com/RekGRpth/echo-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/encrypted-session-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/form-input-nginx-module.git \
#    && git clone --recursive https://github.com/RekGRpth/headers-more-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/iconv-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/libjwt.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-access-plus.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-backtrace-ng.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-client-module.git \
    && git clone --recursive https://github.com/RekGRpth/nginx_csrf_prevent.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-eval-module.git \
    && git clone --recursive https://github.com/RekGRpth/NginxExecute.git \
    && git clone --recursive https://github.com/RekGRpth/nginx.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-http-auth-digest.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-jwt-module.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-push-stream-module.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-upload-module.git \
    && git clone --recursive https://github.com/RekGRpth/nginx-uuid4-module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_ctpp2.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_auth_basic_ldap_module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_captcha_module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_headers_module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_htmldoc_module.git \
#    && git clone --recursive https://github.com/RekGRpth/ngx_http_internal_redirect.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_json_module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_response_body_module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_sign_module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_substitutions_filter_module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_http_zip_var_module.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_postgres.git \
    && git clone --recursive https://github.com/RekGRpth/ngx_sqlite.git \
#    && git clone --recursive https://github.com/RekGRpth/njs.git \
#    && git clone --recursive https://github.com/RekGRpth/rds-csv-nginx-module.git \
#    && git clone --recursive https://github.com/RekGRpth/rds-json-nginx-module.git \
#    && git clone --recursive https://github.com/RekGRpth/replace-filter-nginx-module.git \
    && git clone --recursive https://github.com/RekGRpth/set-misc-nginx-module.git \
#    && git clone --recursive https://github.com/RekGRpth/sregex.git \
    && git clone --recursive https://github.com/RekGRpth/xss-nginx-module.git \
#    && cd /usr/src/sregex \
#    && make -j"$(nproc)" install \
    && cd /usr/src/libjwt \
    && cmake . -DBUILD_SHARED_LIBS=true && make -j"$(nproc)" install \
    && cd /usr/src/ctpp2 \
    && cmake . -DCMAKE_INSTALL_PREFIX=/usr/local && make -j"$(nproc)" install \
    && cd /usr/src/nginx \
    && auto/configure \
        "$(find .. -type f -name "config" | grep -v "\.git" | grep -v "\/t\/" | while read -r NAME; do echo "--add-dynamic-module=$(dirname "$NAME")"; done)" \
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
        --modules-path=/usr/local/modules \
        --pid-path=/var/run/nginx.pid \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --user="${USER}" \
        --with-compat \
        --with-file-aio \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_image_filter_module=dynamic \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_ssl_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-pcre \
        --with-pcre-jit \
        --with-stream=dynamic \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-threads \
    && make -j"$(nproc)" install \
    && rm -rf /usr/src \
    && rm /etc/nginx/*.default \
    && mkdir -p /var/cache/nginx \
    && (strip /usr/local/bin/* /usr/local/lib/*.so /usr/local/modules/*.so /usr/sbin/nginx || true) \
    && apk add --no-cache --virtual .nginx-rundeps \
        apache2-utils \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/sbin/nginx /usr/local | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }') \
    && apk del --no-cache .build-deps \
    && ln -sf /usr/local/modules /etc/nginx/modules \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log
