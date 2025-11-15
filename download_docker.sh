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
mkdir -p docker_x86_64
wget -c "https://download.docker.com/linux/static/stable/x86_64/docker-28.1.1.tgz" -O docker_x86_64/docker-28.1.1.tgz
}

[ "${NETWORK_REGION}" = "cn" ] && {
mkdir -p docker_x86_64
wget -c "http://199.115.230.237:12345/kubernetes/pkg/docker_x86_64/docker-28.1.1.tgz" -O docker_x86_64/docker-28.1.1.tgz
}

date
