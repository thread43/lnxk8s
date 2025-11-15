#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl delete deployment/busybox

kubectl delete deployment/nginx service/nginx

date
