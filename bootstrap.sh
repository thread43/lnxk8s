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

bash init.sh
[ "${WITH_DOWNLOAD}" == "yes" ] && bash download.sh
bash unpkg.sh
bash make.sh
bash stage.sh
bash distribute.sh
bash install.sh
bash setup.sh

ended_at=$(date +%s)

time_elapsed=$((ended_at - started_at))
echo "time elapsed: ${time_elapsed} secs"

date
