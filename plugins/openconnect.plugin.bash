#!/usr/bin/env bash

function start-vpn-background() {
    set -ex
    sudo openconnect \
        --background \
        --syslog \
        --timestamp \
        --pid-file="$HOME/openconnect.pid" \
        --token-mode=rsa \
        --user="$OPENCONNECT_USER" \
        --authgroup="$OPENCONNECT_AUTHGROUP" \
        "$OPENCONNECT_HOST"
    set +ex
}

start-vpn-foreground() {
    set -x
    stoken |
        sudo openconnect \
            --pid-file="$HOME/openconnect.pid" \
            --passwd-on-stdin \
            --user="$OPENCONNECT_USER" \
            --authgroup="$OPENCONNECT_AUTHGROUP" \
            --reconnect-timeout=30 \
            "$OPENCONNECT_HOST"
    set +x
}

start-vpn-foreground-no-stoken() {
    set -x
    sudo openconnect \
        --pid-file="$HOME/openconnect.pid" \
        --user="$OPENCONNECT_USER" \
        --authgroup="$OPENCONNECT_AUTHGROUP" \
        --reconnect-timeout=30 \
        "$OPENCONNECT_HOST"
    set +x
}

stop-vpn() {
    set -ex
    sudo kill $(cat $HOME/openconnect.pid)
    sudo rm -rf "$HOME/openconnect.pid"
    set +ex
}
