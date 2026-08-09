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
wget -c "https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssl-certinfo_1.6.5_linux_amd64" -O cfssl-certinfo_1.6.5_linux_amd64
wget -c "https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssl_1.6.5_linux_amd64"          -O cfssl_1.6.5_linux_amd64
wget -c "https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssljson_1.6.5_linux_amd64"      -O cfssljson_1.6.5_linux_amd64
}

[ "${NETWORK_REGION}" = "cn" ] && {
wget -c "http://199.115.230.237:12345/kubernetes/pkg/cfssl-certinfo_1.6.5_linux_amd64" -O cfssl-certinfo_1.6.5_linux_amd64
wget -c "http://199.115.230.237:12345/kubernetes/pkg/cfssl_1.6.5_linux_amd64"          -O cfssl_1.6.5_linux_amd64
wget -c "http://199.115.230.237:12345/kubernetes/pkg/cfssljson_1.6.5_linux_amd64"      -O cfssljson_1.6.5_linux_amd64
}

date
