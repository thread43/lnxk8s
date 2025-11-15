#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source ./env.sh
echo "${KUBE_APISERVER_IP}"
echo "${LOG_LEVEL}"

mkdir -p artifact/kubernetes/kube-scheduler

cd artifact/kubernetes/kube-scheduler

cat <<EOF >kube-scheduler-csr.json
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "WHATEVER",
      "ST": "WHATEVER",
      "L": "WHATEVER",
      "O": "WHATEVER",
      "OU": "WHATEVER"
    }
  ]
}
EOF

cfssl gencert \
  -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json |cfssljson -bare kube-scheduler

KUBECONFIG="./kube-scheduler.kubeconfig"
KUBE_APISERVER="https://${KUBE_APISERVER_IP}:6443"
[ -f "$KUBECONFIG" ] && rm -f "$KUBECONFIG"
kubectl config set-cluster WHATEVER_CLUSTER_NAME \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG" \
  --server="${KUBE_APISERVER}"
kubectl config set-credentials WHATEVER_USER_NAME \
  --client-certificate=./kube-scheduler.pem \
  --client-key=./kube-scheduler-key.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG"
kubectl config set-context WHATEVER_CONTEXT_NAME \
  --cluster=WHATEVER_CLUSTER_NAME \
  --kubeconfig="$KUBECONFIG" \
  --user=WHATEVER_USER_NAME
kubectl config use-context WHATEVER_CONTEXT_NAME --kubeconfig="$KUBECONFIG"

cat <<EOF >kube-scheduler.conf
KUBE_SCHEDULER_OPTS=" \\
  --authentication-kubeconfig=/opt/kubernetes/kube-scheduler/kube-scheduler.kubeconfig \\
  --authorization-kubeconfig=/opt/kubernetes/kube-scheduler/kube-scheduler.kubeconfig \\
  --bind-address=127.0.0.1 \\
  --kubeconfig=/opt/kubernetes/kube-scheduler/kube-scheduler.kubeconfig \\
  --leader-elect=true \\
  --v=${LOG_LEVEL} \\
"
EOF

cat <<\EOF >kube-scheduler.service
[Unit]
Description=Kubernetes kube-scheduler
Documentation=https://kubernetes.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
EnvironmentFile=/opt/kubernetes/kube-scheduler/kube-scheduler.conf
ExecStart=/opt/kubernetes/kube-scheduler/kube-scheduler $KUBE_SCHEDULER_OPTS
Restart=always

[Install]
WantedBy=multi-user.target
EOF

date
