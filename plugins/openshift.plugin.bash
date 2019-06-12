#!/usr/bin/env bash

# Login to OpenShift cluster, use Mac KeyChain to get password.
oc-login() {
    if [[ ! "$OSTYPE" =~ "darwin" ]]; then
        (echo >&2 "Only works on Mac OS")
        return
    fi

    security_cmd_flags=()
    security_cmd_flags+=(-a "$USER")
    security_cmd_flags+=(-s "$OPENSHIFT_HOST")
    security_cmd_flags+=(-D "appplication password")
    security_cmd_flags+=(-w)
    (
        set +x
        oc login \
            -u "$USER" \
            -p $(/usr/bin/security find-generic-password "${security_cmd_flags[@]}") \
            "https://$OPENSHIFT_HOST"
    )

    oc config current-context
}

# NOTE: by default, OpenShift identity provider allows any password.
oc-create-cluster-admin() {
    (
        set -x
        oc login -u system:admin
        oc create user "cluster-admin"
        oc adm policy add-cluster-role-to-user cluster-admin cluster-admin
    )
}

oc-delete-all() {
    (
        set -x
        oc delete "$(oc get all -o name)"
        oc delete "$(oc get configmap -o name)"
    )
}

oc-tools-bash() {
    (
        set -x
        oc create -f https://raw.githubusercontent.com/tadamo/dockerfiles/master/tools/tools.yaml
        oc wait --for=condition=Ready pod/tools
        oc exec -it tools -- bash
    )
}

# Set the terminal tab title to the config context
oc-set-iterm2-title() {
    iterm2-title "$(oc config current-context)"
}

oc-apply-default-network-policies() {
    read -r -d '' yaml << 'EOF'
{
    "kind": "List",
    "apiVersion": "v1",
    "items": [{
            "apiVersion": "networking.k8s.io/v1",
            "kind": "NetworkPolicy",
            "metadata": {
                "name": "deny-from-all"
            },
            "spec": {
                "podSelector": {},
                "policyTypes": [
                    "Ingress"
                ]
            }
        },
        {
            "apiVersion": "networking.k8s.io/v1",
            "kind": "NetworkPolicy",
            "metadata": {
                "name": "allow-from-same-namespace"
            },
            "spec": {
                "ingress": [{
                    "from": [{
                        "podSelector": {}
                    }]
                }],
                "podSelector": {},
                "policyTypes": [
                    "Ingress"
                ]
            }
        },
        {
            "apiVersion": "networking.k8s.io/v1",
            "kind": "NetworkPolicy",
            "metadata": {
                "name": "allow-from-default-namespace"
            },
            "spec": {
                "ingress": [{
                    "from": [{
                        "namespaceSelector": {
                            "matchLabels": {
                                "name": "default"
                            }
                        }
                    }]
                }],
                "podSelector": {},
                "policyTypes": [
                    "Ingress"
                ]
            }
        }
    ]
}
EOF
    (
        set -x
        echo "$yaml" | oc apply -f -
    )
}
