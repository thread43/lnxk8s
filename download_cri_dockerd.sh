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
wget -c "https://github.com/Mirantis/cri-dockerd/releases/download/v0.4.9/cri-dockerd-0.4.9.amd64.tgz" -O cri-dockerd-0.4.9.amd64.tgz
}

[ "${NETWORK_REGION}" = "cn" ] && {
wget -c "http://199.115.230.237:12345/kubernetes/pkg/cri-dockerd-0.4.9.amd64.tgz" -O cri-dockerd-0.4.9.amd64.tgz
}

date
