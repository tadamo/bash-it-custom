#!/usr/bin/env bash

minishift-down() {
    set -x
    minishift stop
    minishift delete
    (cd ~/.minishift && rm -rf !(cache) && ls -laF)
    set +x
}

minishift-start() {
    set -x
    minishift-down

    minishift profile set "$USER"
    minishift config set memory 8GB
    minishift config set cpus 3
    minishift config set vm-driver virtualbox
    minishift config set image-caching true
    minishift config set insecure-registry "$docker_registry"
    minishift addon enable admin-user

    minishift start

    minishift ip --set-static

    minishift status
    oc login -u system:admin
    oc get pods --all-namespaces
    set +x
}

minishift-systemadmin-login() {
    oc login -u system:admin "https://$(minishift ip):8443"
}

minishift-developer-login() {
    oc login -u developer "https://$(minishift ip):8443"
}
