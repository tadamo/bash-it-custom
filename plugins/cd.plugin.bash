#!/usr/bin/env bash

cd() {
    builtin cd "$@";

    # Always list directory contents upon 'cd'
    ls -l --all --color --classify --human-readable;

    # Don't continue if git command can't be found.
    if ! [ -x "$(command -v git)" ]; then
        exit
    fi

    # If the current working directory matches the git repo root
    # directory, do a git pull.
    if [ "$PWD" == "$(git rev-parse --show-toplevel)" ]; then
        git pull
    fi
}
