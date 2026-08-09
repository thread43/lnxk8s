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
wget -c "https://github.com/etcd-io/etcd/releases/download/v3.5.24/etcd-v3.5.24-linux-amd64.tar.gz" -O etcd-v3.5.24-linux-amd64.tar.gz
}

[ "${NETWORK_REGION}" = "cn" ] && {
wget -c "http://199.115.230.237:12345/kubernetes/pkg/etcd-v3.5.24-linux-amd64.tar.gz" -O etcd-v3.5.24-linux-amd64.tar.gz
}

date
