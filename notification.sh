#!/usr/bin/env bash

slack_notification() {
    local msg=$1
    local payload="{\"text\":\"${msg}\",\"link_names\":true}"
    
    if [[ ! -z $SLACK_WEBHOOK ]]; then
        log "sending slack notification"
        curl -X POST -d "${payload}" -H "Content-Type: application/json" -s ${SLACK_WEBHOOK} > /dev/null
    fi
}
