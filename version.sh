#!/usr/bin/env bash

VERSION_FILE=$1

bashlib_version() {
    cat "$VERSION_FILE"
}
