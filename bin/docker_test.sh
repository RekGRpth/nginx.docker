#!/bin/sh -eux

cd "$HOME"
find "$HOME/src/nginx/modules" -type d -name "t" | grep -v "\.git" | sort | while read -r NAME; do
    cd "$(dirname "$NAME")" && prove
done
