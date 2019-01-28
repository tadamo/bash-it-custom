#!/usr/bin/env bash

docker_stop_all_containers() {
    docker stop "$(docker ps -aq)"
}

docker_rm_all_containers() {
    docker rm "$(docker ps -aq)"
}

docker_rm_all_images() {
    docker rmi "$(docker images -q)"
}

docker_rm_all_networks() {
    docker network rm "$(docker network ls -q)"
}

docker_rm_vm() {
    rm -rf ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/Docker.qcow2
}

docker_system_prune_everything() {
    docker system prune --force --all --volumes
}
