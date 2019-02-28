#!/usr/bin/env bash

fed() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
        -o -type d -print 2> /dev/null | fzf +m)
    [[ -n "$dir" ]] && ${EDITOR:-vim} "${dir[@]}"
}

drb() {
    local docker_image
    docker_image=$(
        docker images \
            --format "{{.Repository}}:{{.Tag}}" \
            --filter="dangling=false" \
            --digests=true | sort -u | fzf +m
    )
    [[ -n "$docker_image" ]] &&
        docker run \
            -it \
            --rm \
            --entrypoint=sh \
            "${docker_image[@]}" \
            -c 'bash || sh'
}

oc-project() {
    local project
    project=$(
        oc get \
            projects \
            -o go-template \
            --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' |
            sort -u | fzf +m
    )
    [[ -n "$project" ]] &&
        oc project "$project"
}
