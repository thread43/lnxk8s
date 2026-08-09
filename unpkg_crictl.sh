#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/crictl

cd pkg

[ -d crictl ] && rm -rf crictl
mkdir -p crictl
tar xzf crictl-v1.33.0-linux-amd64.tar.gz -C crictl

chown -R root:root crictl

chmod +x crictl/crictl

cp -a crictl/crictl ../artifact/crictl/crictl

date
