#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/etcd

cd pkg

[ -d etcd-v3.5.24-linux-amd64 ] && rm -rf etcd-v3.5.24-linux-amd64
tar xzf etcd-v3.5.24-linux-amd64.tar.gz

chown -R root:root etcd-v3.5.24-linux-amd64

chmod +x etcd-v3.5.24-linux-amd64/etcd
chmod +x etcd-v3.5.24-linux-amd64/etcdctl

cp -a etcd-v3.5.24-linux-amd64/etcd    ../artifact/etcd/etcd
cp -a etcd-v3.5.24-linux-amd64/etcdctl ../artifact/etcd/etcdctl

date
