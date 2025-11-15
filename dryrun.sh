#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source ./env.sh
echo "${WITH_DOWNLOAD}"

started_at=$(date +%s)

[ -d artifact ] && rm -rf artifact

[ "${WITH_DOWNLOAD}" == "yes" ] && bash download.sh
bash unpkg.sh
bash make.sh
bash stage.sh

ended_at=$(date +%s)

time_elapsed=$((ended_at - started_at))
echo "time elapsed: ${time_elapsed} secs"

date
