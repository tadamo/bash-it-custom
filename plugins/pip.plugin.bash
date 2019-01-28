#!/usr/bin/env bash

pip-upgrade-outdate() {
    pip install $(pip list --outdated --format json | jq -crM '.[].name') --upgrade
}
