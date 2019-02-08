#!/usr/bin/env bash

minishift-down() {
    (
        set -x
        minishift stop
        minishift delete
        (cd ~/.minishift && rm -rf !(cache) && ls -laF)
    )
}

minishift-start() {
    (
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

        minishift status
        oc login -u system:admin
        oc create user "cluster-admin"
        oc adm policy add-cluster-role-to-user cluster-admin cluster-admin
        oc get pods --all-namespaces
    )
}

minishift-cluster-admin-login() {
    (
        set -x
        oc login \
            --insecure-skip-tls-verify \
            -u cluster-admin \
            -p cluster-admin \
            "https://$(minishift ip):8443"
    )
}

minishift-developer-login() {
    (
        set -x
        oc login \
            --insecure-skip-tls-verify \
            -u developer \
            -p foo \
            "https://$(minishift ip):8443"
    )
}
