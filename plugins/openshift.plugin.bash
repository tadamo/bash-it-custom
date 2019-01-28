#!/usr/bin/env bash

# NOTE: by default, OpenShift identity provider allows any password.
oc-create-cluster-admin() {
    oc login -u system:admin
    oc create user "cluster-admin"
    oc adm policy add-cluster-role-to-user cluster-admin cluster-admin
}

oc-delete-all() {
    oc delete "$(oc get all -o name)"
    oc delete "$(oc get configmap -o name)"
}

oc-tools-bash() {
    oc create -f https://raw.githubusercontent.com/tadamo/dockerfiles/master/tools/tools.yaml
    until $(oc get pod tools &> /dev/null); do sleep 1; done
    oc exec -it tools -- bash
}
