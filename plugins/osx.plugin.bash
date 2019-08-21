#!/usr/bin/env bash

# If connected to power, turn up brightness.
ac_adapter_connected_turn_up_brightness() {
    if ac_adapter_connected; then
        # Won't be able to change external monitors, hide STDERR
        # https://apple.stackexchange.com/questions/61045/does-apple-support-ddc-ci-for-3rd-party-displays-via-apples-thunderbolt-to-dvi
        brightness 1 2> /dev/null
    fi
}

# Run on load up.
if [ $(uname) = "Darwin" ]; then
    ac_adapter_connected_turn_up_brightness
fi
