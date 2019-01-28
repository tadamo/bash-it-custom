#!/usr/bin/env bash

function vault-login-ldap(){
    vault login -method=ldap username="$USER"
}
