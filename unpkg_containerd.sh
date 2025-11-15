#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/containerd

cd pkg

[ -d containerd ] && rm -rf containerd
mkdir -p containerd
tar xzf containerd-1.7.29-linux-amd64.tar.gz -C containerd

chown -R root:root containerd

chmod +x containerd/bin/containerd
chmod +x containerd/bin/containerd-shim         || true # v1
chmod +x containerd/bin/containerd-shim-runc-v1 || true # v1
chmod +x containerd/bin/containerd-shim-runc-v2
chmod +x containerd/bin/containerd-stress
chmod +x containerd/bin/ctr

cp -a containerd/bin/containerd              ../artifact/containerd/containerd
cp -a containerd/bin/containerd-shim         ../artifact/containerd/containerd-shim         || true # v1
cp -a containerd/bin/containerd-shim-runc-v1 ../artifact/containerd/containerd-shim-runc-v1 || true # v1
cp -a containerd/bin/containerd-shim-runc-v2 ../artifact/containerd/containerd-shim-runc-v2
cp -a containerd/bin/containerd-stress       ../artifact/containerd/containerd-stress
cp -a containerd/bin/ctr                     ../artifact/containerd/ctr

date
