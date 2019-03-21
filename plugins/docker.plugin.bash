#!/usr/bin/env bash

docker-stop-all-containers() {
    (
        set -x
        docker stop "$(docker ps -aq)"
    )
}

docker-rm-all-containers() {
    (
        set -x
        docker rm "$(docker ps -aq)"
    )
}

docker-rm-all-images() {
    (
        set -x
        docker rmi "$(docker images -q)"
    )
}

docker-rm-all-networks() {
    (
        set -x
        docker network rm "$(docker network ls -q)"
    )
}

docker_rm_vm() {
    rm -rf ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/Docker.qcow2
}

docker-system-prune-everything() {
    (
        set -x
        docker system prune --force --all --volumes
    )
}
