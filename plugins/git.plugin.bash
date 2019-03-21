#!/usr/bin/env bash

git-delete-merged-local-branches() {
    git branch --merged | egrep -v "(^\*|master|dev|release)" | xargs git branch -d
}
