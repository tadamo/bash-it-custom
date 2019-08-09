#!/usr/bin/env bash

fed() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
        -o -type d -print 2> /dev/null | fzf)
    [[ -n "$dir" ]] && ${EDITOR:-vim} "${dir[@]}"
}

# fuzzy find bitbucket repo directories
fbb() {
    local dir
    dir=$(find "$BITBUCKET_HOME" -type d -maxdepth 2 -mindepth 2 | fzf)
    [[ -n "$dir" ]] && ${EDITOR:-vim} "${dir[@]}"
}

drb() {
    local docker_image
    docker_image=$(
        docker images \
            --format "{{.Repository}}:{{.Tag}}" \
            --filter="dangling=false" \
            --digests=true | sort -u | fzf
    )
    [[ -n "$docker_image" ]] &&
        (
            set -x
            docker run \
                -it \
                --rm \
                --entrypoint=sh \
                "${docker_image[@]}" \
                -c 'bash || sh'
        )
}

oc-project() {
    local project
    project=$(
        oc get \
            projects \
            -o go-template \
            --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' |
            sort -u | fzf
    )
    [[ -n "$project" ]] &&
        (
            set -x
            oc project "$project"
        )
}

oc-show-secret() {
    local secret
    secret=$(
        oc get \
            secrets \
            -o go-template \
            --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' |
            sort -u | fzf
    )
    [[ -n "$secret" ]] &&
        (
            set -x
            oc get secret "$secret" -o json | jq -crM '.data | keys[] as $k | "\($k): \(.[$k] | @base64d)"'
        )
}

dco() {
    command="$1"
    shift
    local service
    service=$(
        docker-compose --log-level ERROR config |
            yq -crM '.services | keys[]' |
            sort -u | fzf
    )
    [[ -n "$service" ]] &&
        (
            set -x
            docker-compose "$command" "$service" "$@"
        )
}

dco-run() {
    dco "run" "$@"
}

dco-up() {
    dco "up" "$@"
}

dco-build() {
    dco "build" "$@"
}
