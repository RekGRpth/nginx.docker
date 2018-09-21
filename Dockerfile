FROM alpine

MAINTAINER RekGRpth

ADD entrypoint.sh /

ENV GROUP=nginx \
    HOME=/data/nginx \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=nginx

RUN CONFIG=" \
		--prefix=/etc/nginx \
		--sbin-path=/usr/sbin/nginx \
		--modules-path=/usr/lib/nginx/modules \
		--conf-path=/etc/nginx/nginx.conf \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
		--user=nginx \
		--group=nginx \
		--with-http_ssl_module \
		--with-threads \
		--with-stream \
		--with-stream_ssl_module \
		--with-compat \
		--with-file-aio \
		--with-http_v2_module \
		--add-dynamic-module=/usr/src/nchan \
		--add-dynamic-module=/usr/src/postgres \
		--add-dynamic-module=/usr/src/echo \
	" \
	&& addgroup -S nginx \
	&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
	&& apk add --no-cache --virtual .build-deps \
		gcc \
		git \
		libc-dev \
		linux-headers \
		make \
		pcre-dev \
		postgresql-dev \
		zlib-dev \
	&& mkdir -p /usr/src \
	&& git clone --progress https://github.com/nginx/nginx.git /usr/src/nginx \
	&& git clone --progress https://github.com/slact/nchan.git /usr/src/nchan \
	&& git clone --progress https://github.com/RekGRpth/ngx_postgres.git /usr/src/postgres \
	&& git clone --progress https://github.com/openresty/echo-nginx-module.git /usr/src/echo \
	&& cd /usr/src/nginx \
	&& auto/configure $CONFIG \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
	&& rm -rf /etc/nginx/html/ \
	&& mkdir /etc/nginx/conf.d/ \
	&& mkdir -p /usr/share/nginx/html/ \
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
	&& usermod --home "${HOME}" "${USER}" \
	&& rm -f /etc/nginx/conf.d/*.conf

COPY nginx.conf /etc/nginx/nginx.conf

VOLUME  ${HOME}

WORKDIR ${HOME}

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "nginx" ]
