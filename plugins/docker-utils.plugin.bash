#!/usr/bin/env bash

docker-dir-size-report() {
    docker pull debian
    docker run \
        --rm \
        -v "$PWD:$PWD:ro" \
        -w=$PWD \
        debian \
        sh -c 'du -h --max-depth=3 | sort -h'
}

docker-perlcritic-tree() {
    docker pull "$docker_registry/image-hub/perl-critic:latest"
    docker run \
        -it \
        --rm \
        -v "$PWD:/app" \
        -w="/app" \
        -e "SKIP_TEST_FORMATTER=1" \
        "$docker_registry/image-hub/perl-critic:latest" \
        /critic/perl-critic-tree
}

docker-perlcritic() {
    docker pull "$docker_registry/image-hub/perl-critic:latest"
    docker run \
        -it \
        --rm \
        -v "$PWD:/app" \
        -w="/app" \
        -e "SKIP_TEST_FORMATTER=1" \
        "$docker_registry/image-hub/perl-critic:latest" \
        /critic/perl-critic "$*"
}

docker-perltidy-tree() {
    docker pull "$docker_registry/image-hub/perl-critic:latest"
    docker run \
        -it \
        --rm \
        -v "$PWD:/work-dir" \
        -w="/work-dir" \
        "$docker_registry/image-hub/perl-critic:latest" \
        /critic/perltidy-tree
}

docker-ub-perl-test() {
    docker pull "$docker_registry/image-hub/ubol-perl-eas:1"
    docker run \
        -it \
        --rm \
        -v "$HOME/test:/test" \
        --workdir=/test \
        "$docker_registry/image-hub/ubol-perl-eas:1" \
        bash
}

docker-oc() {
    docker pull "$docker_registry/image-hub/openshift-cli:1" > /dev/null
    docker run \
        -it \
        --rm \
        --entrypoint="" \
        -v "$HOME/.kube/config:/root/.kube/config" \
        -v "$PWD:$PWD" \
        -w="$PWD" \
        -e KUBECONFIG="/root/.kube/config" \
        "$docker_registry/image-hub/openshift-cli" \
        oc "$*"
}

docker-oc-login() {
    (
        set -x
        oc whoami -t | docker login -u "$USER" --password-stdin "$docker_registry"
    )
}

docker-socat() {
    #https://stackoverflow.com/questions/41267305/docker-for-mac-vm-ip
    # Able to use private IP (192.168.#.#) to access docker process.
    docker run -p 2376:2375 -v /var/run/docker.sock:/var/run/docker.sock bobrik/socat TCP4-LISTEN:2375,fork,reuseaddr UNIX-CONNECT:/var/run/docker.sock
}

docker-cookiecutter-template() {
    this_pwd="$(pwd)"
    docker run \
        --rm \
        -it \
        -v "$this_pwd:$this_pwd" \
        -w="$this_pwd" \
        "$docker_registry/image-hub/cookiecutter:latest" \
        "$*"
}

docker-cookiecutter-perl-mojo-docker() {
    docker-cookiecutter-template "perl-mojo-docker"
}

docker-cookiecutter-docker() {
    docker-cookiecutter-template "docker"
}

docker-check-remote-port() {
    (
        set -x
        docker run \
            --rm \
            -it \
            tadamo/tools:latest \
            bash -c "nc -zv $*"
    )
}
