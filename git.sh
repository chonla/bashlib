#!/usr/bin/env bash

last_commit_before() {
    local git_repo_path=$1
    local stamp=$2
    local cwd=`pwd`

    cd $git_repo_path
    local response=`git --no-pager log --before=$version_stamp --pretty=format:"%H" -1`
    cd $cwd

    echo $response
}

git_time_travel_build() {
    local git_repo_path=$1
    local stamp=$2
    local cwd=`pwd`

    local last_commit=`last_commit_before ${git_repo_path} ${stamp}`

    cd $git_repo_path
    log "time travelling to `is_info ${stamp}` (`is_info ${last_commit}`)"
    git checkout $last_commit

    log "building packages"
    yarn && yarn build
    cd $cwd
}