#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/runc

cd pkg

chown -R root:root runc_v1.3.3

chmod +x runc_v1.3.3/runc.amd64

cp -a runc_v1.3.3/runc.amd64 ../artifact/runc/runc

date
