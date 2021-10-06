FROM ghcr.io/rekgrpth/pdf.docker
ADD NimbusSans-Regular.ttf /usr/local/share/fonts/
CMD [ "nginx" ]
ENV GROUP=nginx \
    USER=nginx
RUN set -eux; \
    mkdir -p "${HOME}"; \
    addgroup -S "${GROUP}"; \
    adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}"; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        bison \
        brotli-dev \
        check-dev \
        cjson-dev \
        clang \
        curl \
        expat-dev \
        expect \
        expect-dev \
        ffcall \
        file \
        g++ \
        gcc \
        gd-dev \
        geoip-dev \
        gettext-dev \
        git \
        gnu-libiconv-dev \
        jansson-dev \
        jpeg-dev \
        jq-dev \
        json-c-dev \
        krb5-dev \
        libbsd-dev \
        libc-dev \
        libtool \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        linux-pam-dev \
        make \
        musl-dev \
        openjpeg-dev \
        openldap-dev \
        pcre-dev \
        perl-dev \
        perl-lwp-protocol-https \
        perl-test-nginx \
        perl-utils \
        postgresql \
        postgresql-dev \
        readline-dev \
        sqlite-dev \
        su-exec \
        talloc-dev \
        util-linux-dev \
        valgrind \
        yaml-dev \
        zlib-dev \
    ; \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --virtual .edge-deps \
        perl-test-file \
    ; \
    install -d -m 1775 -o postgres -g postgres /run/postgresql /var/log/postgresql; \
    su-exec postgres pg_ctl initdb --pgdata=/var/lib/postgresql/data; \
    su-exec postgres pg_ctl start --pgdata=/var/lib/postgresql/data; \
    ln -fs /usr/include/gnu-libiconv/iconv.h /usr/include/iconv.h; \
    mkdir -p "${HOME}/src"; \
    cd "${HOME}/src"; \
    git clone https://github.com/RekGRpth/nginx.git; \
    git clone https://github.com/RekGRpth/nginx-tests.git; \
    mkdir -p "${HOME}/src/nginx/modules"; \
    cd "${HOME}/src/nginx/modules"; \
    git clone https://github.com/RekGRpth/echo-nginx-module.git; \
    git clone https://github.com/RekGRpth/encrypted-session-nginx-module.git; \
    git clone https://github.com/RekGRpth/form-input-nginx-module.git; \
    git clone https://github.com/RekGRpth/iconv-nginx-module.git; \
    git clone https://github.com/RekGRpth/nginx_csrf_prevent.git; \
    git clone https://github.com/RekGRpth/nginx-jwt-module.git; \
    git clone https://github.com/RekGRpth/nginx-push-stream-module.git; \
    git clone https://github.com/RekGRpth/nginx-upload-module.git; \
    git clone https://github.com/RekGRpth/nginx-upstream-fair.git; \
    git clone https://github.com/RekGRpth/nginx-uuid4-module.git; \
    git clone https://github.com/RekGRpth/ngx_brotli.git; \
    git clone https://github.com/RekGRpth/ngx_http_auth_basic_ldap_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_auth_pam_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_captcha_module.git; \
    git clone https://github.com/RekGRpth/ngx_http_evaluate_module.git; \
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
    git clone https://github.com/RekGRpth/spnego-http-auth-nginx-module.git; \
    cd "${HOME}/src/nginx/modules/njs"; \
    ./configure; \
    cd "${HOME}/src/nginx"; \
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
        --with-cc-opt="-W -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wmissing-prototypes -Werror -Wno-discarded-qualifiers -g -O" \
        --with-compat \
        --with-debug \
        --with-file-aio \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_degradation_module \
        --with-http_flv_module \
        --with-http_geoip_module=dynamic \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_image_filter_module=dynamic \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-http_xslt_module=dynamic \
        --with-pcre \
        --with-pcre-jit \
        --with-poll_module \
        --with-select_module \
        --with-stream=dynamic \
        --with-stream_geoip_module=dynamic \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-threads \
    ; \
    make -j"$(nproc)" install; \
    rm /etc/nginx/*.default; \
    mkdir -p /var/cache/nginx; \
    cd /; \
    apk add --no-cache --virtual .nginx-rundeps \
        apache2-utils \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
    ; \
    ln -sf /usr/local/lib/nginx /etc/nginx/modules; \
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log; \
    mkdir -p /run/nginx/; \
    cd "${HOME}/src/nginx-tests"; \
    prove .; \
    cd "${HOME}"; \
    find "${HOME}/src/nginx/modules" -type d -name "t" | grep -v "\.git" | sort | while read -r NAME; do \
        DIR="$(dirname "${NAME}")"; \
        cd "${DIR}"; \
        prove; \
    done; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build-deps; \
    apk del --no-cache .edge-deps; \
    find /usr -type f -name "*.a" -delete; \
    find /usr -type f -name "*.la" -delete; \
    rm -rf "${HOME}" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    echo done
