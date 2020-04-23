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

    local registry_base=${DOCKERHUB_SERVER}
    
    if [[ ! -z $registry_base ]]; then
        registry_base="${registry_base}/"
    fi
    
    if [[ -f $dockerfile ]]; then
        log "building `is_info ${registry_base}${img_id}:${tag}` from `is_info ${dockerfile}`"
        docker build --build-arg VERSION=${tag} -t "${registry_base}${img_id}:${tag}" -f "${dockerfile}" .
        IMAGE_CACHE+=("${registry_base}${img_id}:${tag}")
        
        # tag the rest
        for t in "${additional_tags[@]}"
        do
            log "tagging `is_info ${registry_base}${img_id}:${t}` from `is_info ${registry_base}${img_id}:${tag}`"
            docker tag "${registry_base}${img_id}:${tag}" "${registry_base}${img_id}:${t}"
            IMAGE_CACHE+=("${registry_base}${img_id}:${t}")
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
    
    for tag in "${tags_list[@]}"
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

down_current_docker_container() {
    local service=$1
    log "bring service `is_info ${service}` down"
    docker-compose down
}

down_docker_container() {
    local service=$1
    
    log "shutdown service `is_info ${service}`"
    
    cd "docker/${service}"
    
    down_current_docker_container $service
    
    cd "../.."
}

ensure_docker_container() {
    local service=$1
    local cwd=`pwd`
    
    log "ensuring service `is_info ${service}`"
    
    cd "docker/${service}"
    
    if [ $DOWN_CONTAINER_BEFORE_UP == 1 ]; then
        down_current_docker_container $service
    fi
    
    bash -c "./up.sh"
    cd $cwd
}

down_docker_network() {
    local network=$1
    if [ `docker network ls -q -f name="${network}"` ]; then
        log "remove network: ${network}"
        docker network rm "${network}"
    fi
}

ensure_docker_network() {
    local network=$1
    
    if [ ! `docker network ls -q -f name="${network}"` ]; then
        log "create network: ${network}"
        docker network create "${network}"
    fi
}