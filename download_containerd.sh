#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source ./env.sh
echo "${NETWORK_REGION}"

mkdir -p pkg

cd pkg

[ "${NETWORK_REGION}" = "us" ] && {
wget -c "https://github.com/containerd/containerd/releases/download/v1.7.29/containerd-1.7.29-linux-amd64.tar.gz" -O containerd-1.7.29-linux-amd64.tar.gz
}

[ "${NETWORK_REGION}" = "cn" ] && {
wget -c "http://199.115.230.237:12345/kubernetes/pkg/containerd-1.7.29-linux-amd64.tar.gz" -O containerd-1.7.29-linux-amd64.tar.gz
}

date
