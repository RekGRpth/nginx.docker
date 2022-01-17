#!/bin/sh -eux

cd "$HOME/src/libjwt" && autoreconf -vif &&./configure && make -j"$(nproc)" install
#cd "$HOME/src/nginx/modules/njs" && ./configure
cd "$HOME/src/nginx"
auto/configure \
    --add-dynamic-module="$(find modules -type f -name "config" | grep -v "\.git" | grep -v "\/t\/" | while read -r NAME; do echo -n "`dirname "$NAME"` "; done)" \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --group="$GROUP" \
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
    --user="$USER" \
    --with-cc-opt="-W -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wmissing-prototypes -Werror -Wno-discarded-qualifiers -g -O2" \
    --with-compat \
    $(test "$DOCKER_BUILD" = "test" && echo "--with-debug") \
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
;
make -j"$(nproc)" install
rm /etc/nginx/*.default
ln -sf /usr/local/lib/nginx /etc/nginx/modules
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log
mkdir -p /run/nginx
