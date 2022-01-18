#!/bin/sh -eux

addgroup -g 101 -S "$GROUP"
adduser -u 101 -S -D -G "$GROUP" -H -h "$HOME" -s /sbin/nologin "$USER"
