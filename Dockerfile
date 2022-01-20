ARG DOCKER_FROM=lib.docker:latest
FROM "ghcr.io/rekgrpth/$DOCKER_FROM"
ADD bin /usr/local/bin
ADD NimbusSans-Regular.ttf /usr/local/share/fonts/
ARG DOCKER_BUILD=build
CMD [ "nginx" ]
ENV HOME=/var/cache/nginx
STOPSIGNAL SIGQUIT
WORKDIR "$HOME"
ENV GROUP=nginx \
    USER=nginx
RUN set -eux; \
    export DOCKER_BUILD="$DOCKER_BUILD"; \
    chmod +x /usr/local/bin/*.sh; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    if [ "$DOCKER_BUILD" = "build" ]; then \
        addgroup -g 101 -S "$GROUP"; \
        adduser -u 101 -S -D -G "$GROUP" -H -h "$HOME" -s /sbin/nologin "$USER"; \
        apk add --no-cache --virtual .build \
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
            geoip-dev \
            gettext-dev \
            git \
            gnu-libiconv-dev \
            jansson-dev \
            jpeg-dev \
            jq-dev \
            json-c-dev \
            krb5-dev \
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
            pcre2-dev \
            pcre-dev \
            perl-dev \
            postgresql-dev \
            readline-dev \
            sqlite-dev \
            talloc-dev \
            util-linux-dev \
            yaml-dev \
            zlib-dev \
        ; \
        ln -fs /usr/include/gnu-libiconv/iconv.h /usr/include/iconv.h; \
    else \
        apk add --no-cache --virtual .build \
            curl \
            git \
            libbsd-dev \
            perl-lwp-protocol-https \
            perl-test-nginx \
            perl-utils \
            postgresql \
            valgrind \
        ; \
        apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --virtual .edge-deps \
            perl-test-file \
        ; \
    fi; \
    docker_clone.sh; \
    "docker_$DOCKER_BUILD.sh"; \
    cd /; \
    apk add --no-cache --virtual .nginx \
        apache2-utils \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | grep -v "^$" | sort -u | while read -r lib; do test -z "$(find /usr/local/lib -name "$lib")" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    echo done
