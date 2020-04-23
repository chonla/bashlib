#!/usr/bin/env bash

wait_for_callback() {
    param=( "$@" )
    callback=${@: -1}
    unset "param[${#param[@]}-1]"
    wait_for=""
    
    for var in "${param[@]}"
    do
        if [[ ! -z $wait_for ]]; then
            wait_for="${wait_for} && "
        fi
        wait_for="${wait_for}$(vendor_path)/wait-for-it.sh ${var} -q -s -t 30"
    done
    
    wait_for="${wait_for}"
    
    eval "${wait_for}"
    eval "${callback}"
}

wait_for_container_gone() {
    name=$1
    timeout=$2 # in second
    callback=$3
    timelapsed=0
    
    if [[ ! $QUIET -eq 1 ]]; then
        echo "wait_for_container_gone: waiting ${timeout} seconds for ${name} to finish its job"
    fi
    
    while [ `docker ps -q -f name=${name}` ] && [ $timelapsed -lt $timeout ]; do
        sleep 1
        timelapsed=`expr ${timelapsed} + 1`
    done
    
    if [ `docker ps -q -f name=${name}` ]; then
        if [[ ! $QUIET -eq 1 ]]; then
            echo "wait_for_container_gone: ${name} has not finish its job in time"
        fi
    else
        if [[ ! $QUIET -eq 1 ]]; then
            echo "wait_for_container_gone: ${name} has gone after ${timelapsed} seconds"
        fi
        
        eval "${callback}"
    fi
}