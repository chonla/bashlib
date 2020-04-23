#!/usr/bin/env bash

friendly_boolean() {
    if [[ $1 -eq 1 ]]; then
        echo "yes"
    else
        echo "no"
    fi
}
