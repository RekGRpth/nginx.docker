#!/bin/sh -eux

DOCKER_BUILDKIT=1 docker build --progress=plain --tag ghcr.io/rekgrpth/nginx.docker:debug . 2>&1 | tee build.log
