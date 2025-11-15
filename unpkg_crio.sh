#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/crio

cd pkg

[ -d cri-o ] && rm -rf cri-o
mkdir -p cri-o
tar xzf cri-o.amd64.v1.30.12.tar.gz

chown -R root:root cri-o

chmod +x cri-o/bin/conmon
chmod +x cri-o/bin/conmonrs
chmod +x cri-o/bin/crictl
chmod +x cri-o/bin/crio
chmod +x cri-o/bin/crun
chmod +x cri-o/bin/pinns
chmod +x cri-o/bin/runc

cp -a cri-o/bin/conmon   ../artifact/crio/conmon
cp -a cri-o/bin/conmonrs ../artifact/crio/conmonrs
cp -a cri-o/bin/crictl   ../artifact/crio/crictl
cp -a cri-o/bin/crio     ../artifact/crio/crio
cp -a cri-o/bin/crun     ../artifact/crio/crun
cp -a cri-o/bin/pinns    ../artifact/crio/pinns
cp -a cri-o/bin/runc     ../artifact/crio/runc

date
