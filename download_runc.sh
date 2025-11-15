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
mkdir -p runc_v1.3.3
wget -c "https://github.com/opencontainers/runc/releases/download/v1.3.3/runc.amd64" -O runc_v1.3.3/runc.amd64
}

[ "${NETWORK_REGION}" = "cn" ] && {
mkdir -p runc_v1.3.3
wget -c "http://199.115.230.237:12345/kubernetes/pkg/runc_v1.3.3/runc.amd64" -O runc_v1.3.3/runc.amd64
}

date
