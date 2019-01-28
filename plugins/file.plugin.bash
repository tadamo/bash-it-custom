#!/usr/bin/env bash

function clear_and_watch {
    cat /dev/null > $1
    tail -f $1
}

function rpbcopy {
    if [[ -z $SSH_CONNECTION ]]; then
        echo "$*" | tr -d '\r|\f|\n' | pbcopy
    else
        ssh -o 'BatchMode yes' $REMOTEHOST "echo "$*" | tr -d '\r|\f|\n' | pbcopy"
    fi
}

function fp {
    local fp=`readlink -f "$*"`
    echo $fp
    rpbcopy $fp
}
