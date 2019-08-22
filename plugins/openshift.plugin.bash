#!/usr/bin/env bash

# Login to OpenShift cluster, use Mac KeyChain to get password.
oc-login() {
    local login_host=${1:-$OPENSHIFT_HOST}

    if [[ ! "$OSTYPE" =~ "darwin" ]]; then
        (echo >&2 "Only works on Mac OS")
        return
    fi

    security_cmd_flags=()
    security_cmd_flags+=(-a "$USER")
    security_cmd_flags+=(-s "$login_host")
    security_cmd_flags+=(-D "appplication password")
    security_cmd_flags+=(-w)

    echo "Logging into $login_host..."
    (
        set +x
        oc login \
            -u "$USER" \
            -p $(/usr/bin/security find-generic-password "${security_cmd_flags[@]}") \
            "https://$login_host"
    )

    oc config current-context
}

oc-dev-login() {
    oc-login "$OPENSHIFT_DEV_HOST"
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

oc-show-pod-public-ip() {
    read -r -d '' pod_yaml << HEREDOC
      ---
      apiVersion: v1
      kind: Pod
      metadata:
        name: show-pod-public-ip
      spec:
        containers:
        - name: show-pod-public-ip
          image: tadamo/tools:latest
          imagePullPolicy: Always
          command: ["show-public-ip-loop"]
          resources:
            requests:
              cpu: 5m
              memory: 10Mi
            limits:
              cpu: 10m
              memory: 20Mi
HEREDOC
    (
        set -ex
        echo "$pod_yaml" | oc create -f -
        oc wait --for=condition=Ready pod/show-pod-public-ip
        oc logs -f show-pod-public-ip -c show-pod-public-ip
    )
}

# Set the terminal tab title to the config context
oc-set-iterm2-title() {
    iterm2-title "$(oc config current-context)"
}

# List projects I created
oc-my-projects() {
    oc get projects -o json |
        jq -crM ".items[] | select(.metadata.annotations.\"openshift.io/requester\"==\"$USER\")" |
        jq -crM '.metadata | "  \(.name) - \(.annotations."openshift.io/display-name") - \(.annotations."openshift.io/description")"'
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
