#!/bin/sh -eux

addgroup --system --gid 101 "$GROUP"
adduser --system --uid 101 --disabled-password --home "$HOME" --shell /sbin/nologin --ingroup "$GROUP" "$USER"
