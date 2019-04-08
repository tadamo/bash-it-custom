#!/usr/bin/env bash

iterm2-title() {
    echo -ne "\033]0;""$*""\007"
}
