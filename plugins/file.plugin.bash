#!/usr/bin/env bash

find-and-replace-text-in-files() {
    # https://stackoverflow.com/questions/4767396/linux-command-how-to-find-only-text-files
    # https://stackoverflow.com/questions/5119946/find-exec-with-multiple-commands
    (
        set -x
        find \
            . \
            -type f \
            -not -iwholename '*.git*' \
            -exec grep -Iq . {} \; \
            -exec sed -i '' s/"$1"/"$2"/g {} +
    )
}

clear_and_watch() {
    cat /dev/null > $1
    tail -f $1
}

rpbcopy() {
    if [[ -z $SSH_CONNECTION ]]; then
        echo "$*" | tr -d '\r|\f|\n' | pbcopy
    else
        ssh -o 'BatchMode yes' $REMOTEHOST "echo "$*" | tr -d '\r|\f|\n' | pbcopy"
    fi
}

fp() {
    local fp=$(readlink -f "$*")
    echo $fp
    rpbcopy $fp
}
