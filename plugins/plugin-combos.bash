#!/usr/bin/env bash

# combines functions from several plugins

oc-new-session() {
    new-k8s-session
    oc-login
    docker-oc-login
    oc-project
    if [[ "$OSTYPE" =~ "darwin" ]]; then
        oc-set-iterm2-title
    fi
}

oc-new-dev-session() {
    new-k8s-session
    oc-dev-login
    docker-oc-dev-login
    oc-project
    if [[ "$OSTYPE" =~ "darwin" ]]; then
        oc-set-iterm2-title
    fi
}
