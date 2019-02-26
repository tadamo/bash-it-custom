#!/usr/bin/env bash

brew_update_everything() {
    (
        set -x
        brew update &&
            brew upgrade &&
            brew cask upgrade --greedy &&
            brew cleanup
    )
}
