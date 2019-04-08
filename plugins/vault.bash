#!/usr/bin/env bash

vault-login-ldap() {
    vault login -method=ldap username="$USER"
}
