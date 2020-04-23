#!/usr/bin/env bash

image_stamp() {
    local img=$1
    local tag=$2

    local response=`curl -s "https://hub.docker.com/v2/repositories/${img}/tags/${tag}/"`

    local last_updated=`echo $response | jq '.last_updated'`
    echo $last_updated
}