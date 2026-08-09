#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source ./env.sh
echo "${KUBE_APISERVER_IP}"

mkdir -p artifact/kubernetes/kubectl

cd artifact/kubernetes/kubectl

cat <<EOF >kubectl-csr.json
{
  "CN": "WHATEVER",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "WHATEVER",
      "ST": "WHATEVER",
      "L": "WHATEVER",
      "O": "system:masters",
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
  kubectl-csr.json |cfssljson -bare kubectl

KUBECONFIG="./kubectl.kubeconfig"
KUBE_APISERVER="https://${KUBE_APISERVER_IP}:6443"
[ -f "$KUBECONFIG" ] && rm -f "$KUBECONFIG"
kubectl config set-cluster WHATEVER_CLUSTER_NAME \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --kubeconfig="${KUBECONFIG}" \
  --server="${KUBE_APISERVER}"
kubectl config set-credentials WHATEVER_USER_NAME \
  --client-certificate=./kubectl.pem \
  --client-key=./kubectl-key.pem \
  --embed-certs=true \
  --kubeconfig="${KUBECONFIG}"
kubectl config set-context WHATEVER_CONTEXT_NAME \
  --cluster=WHATEVER_CLUSTER_NAME \
  --kubeconfig="${KUBECONFIG}" \
  --user=WHATEVER_USER_NAME
kubectl config use-context WHATEVER_CONTEXT_NAME --kubeconfig="${KUBECONFIG}"

date
