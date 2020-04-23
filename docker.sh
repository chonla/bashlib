#!/usr/bin/env bash

docker_login() {
    local user=$1
    local password=$2
    
    if [[ "${user}" != "" ]] && [[ "${password}" != "" ]]; then
        log "loggin into docker registry"
        echo "${password}" | docker login -u "${user}" --password-stdin ${DOCKERHUB_SERVER}
    fi
}

build_image() {
    local name=$1
    local img_id=$2
    shift 2
    declare -a tags_list=("$@")
    local tag=${tags_list[0]}
    local additional_tags=("${tags_list[@]:1}")
    local dockerfile="${name}.Dockerfile"
    
    if [[ -f $dockerfile ]]; then
        log "building `is_info ${img_id}:${tag}` from `is_info ${dockerfile}`"
        docker build --build-arg VERSION=${tag} -t "${img_id}:${tag}" -f "${dockerfile}" .
        IMAGE_CACHE+=("${img_id}:${tag}")
        
        # tag the rest
        for t in "${additional_tags[@]}"
        do
            log "tagging `is_info ${img_id}:${t}` from `is_info ${img_id}:${tag}`"
            docker tag "${img_id}:${tag}" "${img_id}:${t}"
            IMAGE_CACHE+=("${img_id}:${t}")
        done
    else
        warning_log "cannot find `is_info ${dockerfile}` ... `is_error skipped`"
    fi
}

push_image() {
    local registry_base=${DOCKERHUB_SERVER}
    
    if [[ ! -z $registry_base ]]; then
        registry_base="${registry_base}/"
    fi

    local img_id=$1
    shift
    declare -a tags_list=("$@")
    
    for t in "${tags_list[@]}"
    do
        log "pushing `is_info ${registry_base}${img_id}:${tag}`"
        docker push "${registry_base}${img_id}:${tag}"
    done
}

push_images() {
    local registry_base=${DOCKERHUB_SERVER}
    
    if [[ ! -z $registry_base ]]; then
        registry_base="${registry_base}/"
    fi
    
    for img in "${IMAGE_CACHE[@]}"
    do
        log "pushing `is_info ${img}`"
        docker push "${registry_base}${img}"
    done
}

clear_image_cache() {
    for img in "${IMAGE_CACHE[@]}"
    do
        log "removing `is_info ${img}`"
        docker image rm "${img}"
    done
}