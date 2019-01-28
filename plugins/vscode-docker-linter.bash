#!/usr/bin/env bash

function docker-linter-perl-criticd(){
    docker pull "$docker_registry/image-hub/perl-critic:latest"
    docker run \
        --restart=always \
        -d \
        --name docker-linter \
        "$docker_registry/image-hub/perl-critic:latest" \
        sh -c "while true; do echo 'Hit CTRL+C'; sleep 1; done"
}
