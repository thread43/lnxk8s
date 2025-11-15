#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source ./env.sh
echo "${NETWORK_REGION}"
echo "${KUBERNETES_VERSION}"

mkdir -p pkg

cd pkg

[ "${NETWORK_REGION}" = "us" ] && {
mkdir -p "kubernetes_${KUBERNETES_VERSION}"
wget -c --no-check-certificate "https://dl.k8s.io/${KUBERNETES_VERSION}/kubernetes-server-linux-amd64.tar.gz" -O "kubernetes_${KUBERNETES_VERSION}/kubernetes-server-linux-amd64.tar.gz"
}

[ "${NETWORK_REGION}" = "cn" ] && {
mkdir -p "kubernetes_${KUBERNETES_VERSION}"
wget -c "http://199.115.230.237:12345/kubernetes/pkg/kubernetes_${KUBERNETES_VERSION}/kubernetes-server-linux-amd64.tar.gz" -O "kubernetes_${KUBERNETES_VERSION}/kubernetes-server-linux-amd64.tar.gz"
}

date
