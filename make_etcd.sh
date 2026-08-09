#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

[ "$#" -ne 1 ] && echo "invalid argument, need an ip" && exit 1

ETCD_IP="$1"
echo "${ETCD_IP}"

KEEP_ETCD_IP="${ETCD_IP}"

source ./env.sh
echo "${ETCD_IP_LIST[@]}"
echo "${OS_ARCH}"

mkdir -p artifact/etcd

cd artifact/etcd

cat <<EOF >ca-config.json
{
  "signing": {
    "default": {
      "expiry": "876000h"
    },
    "profiles": {
      "server": {
        "expiry": "876000h",
        "usages": [
          "signing",
          "key encipherment",
          "server auth",
          "client auth"
        ]
      }
    }
  }
}
EOF
cat <<EOF >ca-csr.json
{
  "CN": "WHATEVER",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "WHATEVER",
      "ST": "WHATEVER",
      "L": "WHATEVER"
    }
  ]
}
EOF

HOSTS=""
for ETCD_IP in "${ETCD_IP_LIST[@]}"; do
  HOSTS="${HOSTS},\"${ETCD_IP}\""
done
HOSTS="$(echo "$HOSTS" |sed "s/^,//g")"
echo "$HOSTS"

cfssl gencert -initca ca-csr.json |cfssljson -bare ca

cat <<EOF >server-csr.json
{
  "CN": "WHATEVER",
  "hosts": [
    ${HOSTS}
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "WHATEVER",
      "ST": "WHATEVER",
      "L": "WHATEVER"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=server \
  server-csr.json |cfssljson -bare server

INITIAL_CLUSTER=""
for ETCD_IP in "${ETCD_IP_LIST[@]}"; do
  ETCD_NAME="$(echo "${ETCD_IP}" |sed "s/\./_/g")"
  INITIAL_CLUSTER="${INITIAL_CLUSTER},etcd_${ETCD_NAME}=https://${ETCD_IP}:2380"
done
INITIAL_CLUSTER="$(echo "${INITIAL_CLUSTER}" |sed "s/^,//g")"
echo "${INITIAL_CLUSTER}"

ETCD_IP="${KEEP_ETCD_IP}"
ETCD_NAME="$(echo "${ETCD_IP}" |sed "s/\./_/g")"
echo "${ETCD_IP}"
echo "${ETCD_NAME}"

cat <<EOF >"etcd_${ETCD_NAME}.conf"
ETCD_OPTS=" \\
  --advertise-client-urls=https://${ETCD_IP}:2379 \\
  --cert-file=/opt/etcd/server.pem \\
  --client-cert-auth=true \\
  --data-dir=/var/lib/etcd \\
  --experimental-initial-corrupt-check=true \\
  --experimental-watch-progress-notify-interval=5s \\
  --initial-advertise-peer-urls=https://${ETCD_IP}:2380 \\
  --initial-cluster=${INITIAL_CLUSTER} \\
  --key-file=/opt/etcd/server-key.pem \\
  --listen-client-urls=https://127.0.0.1:2379,https://${ETCD_IP}:2379 \\
  --listen-metrics-urls=http://127.0.0.1:2381 \\
  --listen-peer-urls=https://${ETCD_IP}:2380 \\
  --name=etcd_${ETCD_NAME} \\
  --peer-cert-file=/opt/etcd/server.pem \\
  --peer-client-cert-auth=true \\
  --peer-key-file=/opt/etcd/server-key.pem \\
  --peer-trusted-ca-file=/opt/etcd/ca.pem \\
  --snapshot-count=10000 \\
  --trusted-ca-file=/opt/etcd/ca.pem \\
"
EOF
if [ "${OS_ARCH}" = "arm64" ]; then
  echo "ETCD_UNSUPPORTED_ARCH=arm64" >>"etcd_${ETCD_NAME}.conf"
fi

cat <<\EOF >etcd.service
[Unit]
Description=Etcd
Documentation=https://etcd.io/docs/
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
EnvironmentFile=/opt/etcd/etcd.conf
ExecStart=/opt/etcd/etcd $ETCD_OPTS
Restart=always

[Install]
WantedBy=multi-user.target
EOF

date
