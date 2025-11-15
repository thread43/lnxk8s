#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/docker

cd pkg

[ -d docker ] && rm -rf docker
tar xzf docker_x86_64/docker-28.1.1.tgz

chown -R root:root docker

chmod +x docker/containerd
chmod +x docker/containerd-shim-runc-v2
chmod +x docker/ctr
chmod +x docker/docker
chmod +x docker/docker-init
chmod +x docker/docker-proxy
chmod +x docker/dockerd
chmod +x docker/runc

cp -a docker/containerd              ../artifact/docker/containerd
cp -a docker/containerd-shim-runc-v2 ../artifact/docker/containerd-shim-runc-v2
cp -a docker/ctr                     ../artifact/docker/ctr
cp -a docker/docker                  ../artifact/docker/docker
cp -a docker/docker-init             ../artifact/docker/docker-init
cp -a docker/docker-proxy            ../artifact/docker/docker-proxy
cp -a docker/dockerd                 ../artifact/docker/dockerd
cp -a docker/runc                    ../artifact/docker/runc

date
