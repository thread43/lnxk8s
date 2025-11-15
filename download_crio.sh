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
wget -c "https://storage.googleapis.com/cri-o/artifacts/cri-o.amd64.v1.30.12.tar.gz" -O cri-o.amd64.v1.30.12.tar.gz
}

[ "${NETWORK_REGION}" = "cn" ] && {
wget -c "http://199.115.230.237:12345/kubernetes/pkg/cri-o.amd64.v1.30.12.tar.gz" -O cri-o.amd64.v1.30.12.tar.gz
}

date
