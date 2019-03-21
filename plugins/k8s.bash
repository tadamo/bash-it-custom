#!/usr/bin/env bash

new-k8s-session() {
    # make a directory to store a kube config file per bash session
    KUBE_SESSION_DIRECTORY="$HOME/.kube-session"
    export KUBE_SESSION_DIRECTORY

    # $$ is the PID of the current bash shell
    KUBECONFIG_CURRENT_SESSION_DIRECTORY="$KUBE_SESSION_DIRECTORY/$$"
    export KUBECONFIG_CURRENT_SESSION_DIRECTORY

    mkdir -p "$KUBECONFIG_CURRENT_SESSION_DIRECTORY"

    # Find all session directories and delete the ones no longer needed.
    old_session_pids=$(find "$KUBE_SESSION_DIRECTORY" -type d -maxdepth 1 -mindepth 1 | sed "s|$KUBE_SESSION_DIRECTORY/||")
    for pid in $old_session_pids; do
        if ! kill -0 "$pid" > /dev/null 2>&1; then
            rm -rf "${KUBE_SESSION_DIRECTORY:?}/$pid"
        fi
    done

    # Set KUBECONFIG to the session directory config
    KUBECONFIG="$KUBECONFIG_CURRENT_SESSION_DIRECTORY/config"
    export KUBECONFIG
}
