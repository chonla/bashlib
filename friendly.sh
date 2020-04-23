#!/usr/bin/env bash

friendly_optional() {
    if [[ -z $1 ]]; then
        echo $2
    else
        echo $1
    fi
}

friendly_boolean() {
    if [[ $1 -eq 1 ]]; then
        echo "yes"
    else
        echo "no"
    fi
}
