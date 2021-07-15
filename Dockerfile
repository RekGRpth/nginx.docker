FROM rekgrpth/pdf
CMD [ "nginx" ]
ENV GROUP=nginx \
    LD_PRELOAD=/usr/lib/preloadable_libiconv.so \
    USER=nginx
VOLUME "${HOME}"
RUN set -eux; \
    mkdir -p "${HOME}"; \
    addgroup -S "${GROUP}"; \
    adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}"; \
    apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        bison \
        brotli-dev \
        check-dev \
        cjson-dev \
        clang \
        expat-dev \
        expect \
        expect-dev \
        ffcall \
        file \
        g++ \
        gcc \
        gd-dev \
        gettext-dev \
        git \
        gnu-libiconv-dev \
        jansson-dev \
        jpeg-dev \
        jq-dev \
        json-c-dev \
        libc-dev \
        libtool \
        libunwind-dev \
        linux-headers \
        make \
        musl-dev \
        openjpeg-dev \
        openldap-dev \
        pcre-dev \
        perl-dev \
        postgresql-dev \
        readline-dev \
        sqlite-dev \
        talloc-dev \
        valgrind \
        yaml-dev \
        zlib-dev \
    ; \
    mkdir -p "${HOME}"; \
    cd "${HOME}"; \
    git clone https://bitbucket.org/RekGRpth/nginx.git; \
    cd "${HOME}/nginx"; \
    mkdir -p /usr/local/share/fonts; \
    cp -rf NimbusSans-Regular.ttf /usr/local/share/fonts; \
    cd "${HOME}"; \
    rm -rf "${HOME}/nginx"; \
    git clone https://github.com/RekGRpth/libjwt.git; \
    git clone https://github.com/RekGRpth/nginx.git; \
    mkdir -p "${HOME}/nginx/modules"; \
    cd "${HOME}/nginx/modules"; \
    git clone https://github.com/RekGRpth/echo-nginx-module.git; \
    git clone https://github.com/RekGRpth/encrypted-session-nginx-module.git; \
    git clone https://github.com/RekGRpth/form-input-nginx-module.git; \
    git clone https://github.com/RekGRpth/iconv-nginx-module.git; \
    git clone https://github.com/RekGRpth/nginx-backtrace-ng.git; \
    git clone https://github.com/RekGRpth/nginx_csrf_prevent.git; \
    git clone https://github.com/RekGRpth/nginx-eval-module.git; \
    git clone https://github.com/RekGRpth/nginx-http-auth-digest.git; \
    git clone https://github.com/RekGRpth/nginx-jwt-module.git; \
    git clone https://github.com/RekGRpth/nginx-push-stream-module.git; \
    git clone https://github.com/RekGRpth/nginx-upload-module.git; \
    git clone https://github.com/RekGRpth/nginx-uuid4-module.git; \
    git clone https://github.com/RekGRpth/ngx_brotli.git; \
    git clone https://github.com/RekGRpth/ngx_http_auth_basic_ldap_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_captcha_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_handlebars_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_headers_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_htmldoc_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_json_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_mustach_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_response_body_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_sign_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_substitutions_filter_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_upstream_session_sticky_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_zip_var_module.git; \
    git clone https://github.com/RekGRpth/ngx_postgres.git; \
    git clone https://github.com/RekGRpth/njs.git; \
    git clone https://github.com/RekGRpth/set-misc-nginx-module.git; \
    cd "${HOME}/libjwt"; \
    autoreconf -vif; \
    ./configure; \
    make -j"$(nproc)" install; \
    cd "${HOME}/nginx/modules/njs"; \
    ./configure; \
    cd "${HOME}/nginx"; \
    export CFLAGS="$CFLAGS -W -Wall -Wextra -Wno-unused-parameter -Wmissing-prototypes -Werror -g -O"; \
    export CPPFLAGS="$CPPFLAGS -W -Wall -Wextra -Wno-unused-parameter -Wmissing-prototypes -Werror -g -O"; \
    auto/configure \
        --add-dynamic-module="$(find modules -type f -name "config" | grep -v "\.git" | grep -v "\/t\/" | while read -r NAME; do echo -n "`dirname "$NAME"` "; done)" \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --group="${GROUP}" \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-log-path=/var/log/nginx/access.log \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --lock-path=/run/nginx/nginx.lock \
        --modules-path=/usr/local/lib/nginx \
        --pid-path=/run/nginx/nginx.pid \
        --prefix=/etc/nginx \
        --sbin-path=/usr/local/bin/nginx \
        --user="${USER}" \
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
        --with-stream_ssl_preread_module \
        --with-threads \
    ; \
    make -j"$(nproc)" install; \
    rm /etc/nginx/*.default; \
    mkdir -p /var/cache/nginx; \
    cd "${HOME}"; \
    apk add --no-cache --virtual .nginx-rundeps \
        apache2-utils \
        gnu-libiconv \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin /usr/local/lib -type f -exec strip '{}' \;; \
    apk del --no-cache .build-deps; \
    find / -type f -name "*.a" -delete; \
    find / -type f -name "*.la" -delete; \
    rm -rf "${HOME}" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    ln -sf /usr/local/lib/nginx /etc/nginx/modules; \
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log; \
    mkdir -p /run/nginx/; \
    echo done
