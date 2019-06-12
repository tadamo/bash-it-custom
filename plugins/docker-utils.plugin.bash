#!/usr/bin/env bash

# Login to Docker HUB, use Mac KeyChain to get password.
docker-hub-login() {
    if [[ ! "$OSTYPE" =~ "darwin" ]]; then
        (echo >&2 "Only works on Mac OS")
        return
    fi

    security_cmd_flags=()
    security_cmd_flags+=(-a "$USER")
    security_cmd_flags+=(-s "hub.docker.com")
    security_cmd_flags+=(-D "appplication password")
    security_cmd_flags+=(-w)
    (
        set +x
        /usr/bin/security find-generic-password "${security_cmd_flags[@]}" |
            docker login -u "$USER" --password-stdin
    )
}

# Login to RedHat Registry, use Mac KeyChain to get password.
docker-redhat-login() {
    if [[ ! "$OSTYPE" =~ "darwin" ]]; then
        (echo >&2 "Only works on Mac OS")
        return
    fi

    security_cmd_flags=()
    security_cmd_flags+=(-a "$REDHAT_REGISTRY_USER")
    security_cmd_flags+=(-s "registry.redhat.io")
    security_cmd_flags+=(-D "appplication password")
    security_cmd_flags+=(-w)
    (
        set -x
        /usr/bin/security find-generic-password "${security_cmd_flags[@]}" |
            docker login -u "$REDHAT_REGISTRY_USER" --password-stdin registry.redhat.io
    )
}

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

# Connect example:
#  docker-sqlplus "username/passowrd@db-host.example.com:1521/db-service-name"
docker-sqlplus() {
    sqlplus_docker_image="${sqlplus_docker_image:-store/oracle/database-instantclient:12.2.0.1}"
    (
        set -x
        docker run \
            -it \
            --rm \
            "$sqlplus_docker_image" \
            sh -c "sqlplus $*"
    )
}

docker-sqlplus-trace() {
    local sqlplus_config="${sqlplus_config:-./.sqlplus}"
    if [ -f "$sqlplus_config" ]; then
        source "$sqlplus_config"
    fi

    given_sql="$*"
    local sqlplus_sql="${given_sql:-$sqlplus_sql}"
    local sqlplus_sql="${sqlplus_sql:-SELECT 1 FROM DUAL;}"
    sqlplus_docker_image="${sqlplus_docker_image:-store/oracle/database-instantclient:12.2.0.1}"

    echo "sqlplus_docker_image: $sqlplus_docker_image"
    echo "sqlplus_sql: $sqlplus_sql"
    echo "sqlplus_host: $sqlplus_host"
    echo "sqlplus_service: $sqlplus_service"
    echo "sqlplus_user: $sqlplus_user"

    if [ -z ${sqlplus_host+x} ]; then
        printf "\n sqlplus_host is unset. \n"
        return
    elif [ -z ${sqlplus_service+x} ]; then
        printf "\n sqlplus_service is unset. \n"
        return
    elif [ -z ${sqlplus_user+x} ]; then
        printf "\n sqlplus_user is unset. \n"
        return
    elif [ -z ${sqlplus_password+x} ]; then
        printf "\n sqlplus_password is unset. \n"
        return
    fi

    docker pull "$sqlplus_docker_image"
    sqlplus="
        --------------------------------------------
        set serveroutput on
        set pagesize 0
        set heading off
        set feedback off
        set termout off
        set autotrace traceonly;

        variable n number
        exec :n := dbms_utility.get_time
        --------------------------------------------
        --------------------------------------------

        $sqlplus_sql

        --------------------------------------------
        --------------------------------------------
        exec :n := (dbms_utility.get_time - :n)/100
        exec dbms_output.put_line('sqlplus elapsed seconds: ' || :n)
        exit;
        --------------------------------------------
    " &&
        docker run \
            -it \
            --rm \
            -e "SQLPLUS=$sqlplus" \
            -e "HOST=$sqlplus_host" \
            -e "SERVICE=$sqlplus_service" \
            -e "USER=$sqlplus_user" \
            -e "PASSWORD=$sqlplus_password" \
            "$sqlplus_docker_image" \
            sh -c 'set -e; echo "$SQLPLUS" | sqlplus -L -S -NOLOGINTIME "$USER/$PASSWORD@$HOST/$SERVICE"'
}
