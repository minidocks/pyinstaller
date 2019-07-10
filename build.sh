#!/bin/sh
set -e

image="${namespace:-minidocks}/pyinstaller"
versions="
3.4-py2;3.4;2
3.4-py3;3.4;3
3.4;3.4;3
latest;3.4;3
"

build() {
    docker build $docker_opts --build-arg python_version="$3" --build-arg pyinstaller_version="$2" -t "$image:$1" "$(dirname $0)"
}

case "$1" in
    --versions) echo "$versions" | awk 'NF' | cut -d';' -f1;;
    '') echo "$versions" | grep -v "^$" | while read -r version; do IFS=';'; build $version; done;;
    *) args="$(echo "$versions" | grep -E "^$1(;|$)")"; if [ -n "$args" ]; then IFS=';'; build $args; else echo "Version $1 does not exist." >/dev/stderr; exit 1; fi
esac
