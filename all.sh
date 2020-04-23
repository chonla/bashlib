#!/usr/bin/env bash

# Copyright http://stackoverflow.com/a/7400673/257479
myreadlink() { [ ! -h "$1" ] && echo "$1" || (local link="$(expr "$(command ls -ld -- "$1")" : '.*-> \(.*\)$')"; cd $(dirname $1); myreadlink "$link" | sed "s|^\([^/].*\)\$|$(dirname $1)/\1|"); }
whereis() { echo $1 | sed "s|^\([^/].*/.*\)|$(pwd)/\1|;s|^\([^/]*\)$|$(which -- $1)|;s|^$|$1|"; } 
whereis_realpath() { local SCRIPT_PATH=$(whereis $1); myreadlink ${SCRIPT_PATH} | sed "s|^\([^/].*\)\$|$(dirname ${SCRIPT_PATH})/\1|"; } 

DIR=$(dirname $(whereis_realpath "$0"))

source "${DIR}/lib/color.sh"
source "${DIR}/lib/common.sh"
source "${DIR}/lib/friendly.sh"
source "${DIR}/lib/docker.sh"
source "${DIR}/lib/dockerhub.sh"
source "${DIR}/lib/git.sh"
source "${DIR}/lib/notification.sh"
source "${DIR}/lib/wait.sh"
source "${DIR}/lib/vendor.sh" "${DIR}/lib/vendor/"
source "${DIR}/lib/version.sh" "${DIR}/lib/VERSION"