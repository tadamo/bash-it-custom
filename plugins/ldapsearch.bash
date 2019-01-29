#!/usr/bin/env bash

ldapsearch-query() {
    ldapsearch \
        -o ldif-wrap=no \
        -v \
        -H "$LDAP_SEARCH_URI" \
        -b "$LDAP_SEARCH_BASEDN" \
        -D "$LDAP_SEARCH_BINDDB" \
        -w "$LDAP_SEARCH_PASSWD" \
        "$@"
}
