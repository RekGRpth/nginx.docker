#!/bin/sh -eux

apk update --no-cache
apk upgrade --no-cache
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
;
ln -fs /usr/include/gnu-libiconv/iconv.h /usr/include/iconv.h
