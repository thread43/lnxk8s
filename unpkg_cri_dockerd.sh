#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/cri-dockerd

cd pkg

[ -d cri-dockerd ] && rm -rf cri-dockerd
tar xzf cri-dockerd-0.3.17.amd64.tgz

chown -R root:root cri-dockerd

chmod +x cri-dockerd/cri-dockerd

cp -a cri-dockerd/cri-dockerd ../artifact/cri-dockerd/cri-dockerd

date
