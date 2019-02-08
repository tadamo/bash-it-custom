#!/usr/bin/env bash

function start-vpn-background() {
    sudo openconnect \
        --background \
        --syslog \
        --timestamp \
        --pid-file="$HOME/openconnect.pid" \
        --token-mode=rsa \
        --user="$OPENCONNECT_USER" \
        --authgroup="$OPENCONNECT_AUTHGROUP" \
        "$OPENCONNECT_HOST"
}

start-vpn-foreground() {
    (
        set -x
        stoken |
            sudo openconnect \
                --pid-file="$HOME/openconnect.pid" \
                --passwd-on-stdin \
                --user="$OPENCONNECT_USER" \
                --authgroup="$OPENCONNECT_AUTHGROUP" \
                --reconnect-timeout=30 \
                "$OPENCONNECT_HOST"
    )
}

start-vpn-foreground-no-stoken() {
    sudo openconnect \
        --pid-file="$HOME/openconnect.pid" \
        --user="$OPENCONNECT_USER" \
        --authgroup="$OPENCONNECT_AUTHGROUP" \
        --reconnect-timeout=30 \
        "$OPENCONNECT_HOST"
}

stop-vpn() {
    sudo kill $(cat "$HOME/openconnect.pid")
    sudo rm -rf "$HOME/openconnect.pid"
}
