ARG DOCKER_FROM=lib.docker:latest
FROM "ghcr.io/rekgrpth/$DOCKER_FROM"
ADD bin /usr/local/bin
ADD NimbusSans-Regular.ttf /usr/local/share/fonts/
ARG DOCKER_BUILD=build
ARG DOCKER_TYPE=apk
CMD [ "nginx" ]
ENV HOME=/var/cache/nginx
STOPSIGNAL SIGQUIT
WORKDIR "$HOME"
ENV GROUP=nginx \
    USER=nginx
RUN set -eux; \
    export DOCKER_BUILD="$DOCKER_BUILD"; \
    export DOCKER_TYPE="$DOCKER_TYPE"; \
    if [ $DOCKER_TYPE = "apt" ]; then \
        export DEBIAN_FRONTEND=noninteractive; \
        export savedAptMark="$(apt-mark showmanual)"; \
    else \
        ln -fs su-exec /sbin/gosu; \
    fi; \
    chmod +x /usr/local/bin/*.sh; \
    test "$DOCKER_BUILD" = "build" && "docker_add_group_and_user_$DOCKER_TYPE.sh"; \
    "docker_${DOCKER_BUILD}_$DOCKER_TYPE.sh"; \
    docker_clone.sh; \
    "docker_$DOCKER_BUILD.sh"; \
    "docker_clean_$DOCKER_TYPE.sh"; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    ln -sf /usr/local/lib/nginx /etc/nginx/modules; \
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log; \
    mkdir -p /run/nginx/; \
    echo done
