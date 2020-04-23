#!/usr/bin/env bash

is_title() {
    echo `colorize 34 $*`
}

is_info() {
    echo `colorize 33 $*`
}

is_warning() {
    echo `colorize 33 $*`
}

is_error() {
    echo `colorize 31 $*`
}

colorize() {
    local color=$1
    local text=$2
    if [[ "$MONOCHROME" == "true" ]]; then
        echo "$2"
    else
        echo -e "\e[$1m$2\e[0m"
    fi
}