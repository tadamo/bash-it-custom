#!/usr/bin/env bash

brew_update_everything() {
    brew update &&
        brew upgrade &&
        brew cask list | xargs brew cask install --force &&
        brew cleanup
}
