#!/usr/bin/env bash

log() {
    echo -e "`is_title [${APP_NAME}]` $*"
}

error_log() {
    echo -e "`is_error [${APP_NAME}]` $*"
}

warning_log() {
    echo -e "`is_warning [${APP_NAME}]` $*"
}

parse_env() {
    if [ -f .env ]
    then
        export $(cat .env | sed 's/#.*//g' | xargs)
    fi
}

