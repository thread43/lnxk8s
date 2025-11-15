#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact/kubernetes

cd artifact/kubernetes

cat <<EOF >ca-config.json
{
  "signing": {
    "default": {
      "expiry": "876000h"
    },
    "profiles": {
      "kubernetes": {
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
      "L": "WHATEVER",
      "O": "WHATEVER",
      "OU": "WHATEVER"
    }
  ],
  "ca": {
    "expiry": "876000h"
  }
}
EOF

cfssl gencert -initca ca-csr.json |cfssljson -bare ca

cat <<EOF >front-proxy-ca-config.json
{
  "signing": {
    "default": {
      "expiry": "876000h"
    },
    "profiles": {
      "kubernetes": {
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
cat <<EOF >front-proxy-ca-csr.json
{
  "CN": "WHATEVER",
  "key": {
     "algo": "rsa",
     "size": 2048
  }
}
EOF

cfssl gencert -initca front-proxy-ca-csr.json |cfssljson -bare front-proxy-ca

cat <<EOF >front-proxy-client-csr.json
{
  "CN": "front-proxy-client",
  "key": {
     "algo": "rsa",
     "size": 2048
  }
}
EOF

cfssl gencert \
  -ca=front-proxy-ca.pem \
  -ca-key=front-proxy-ca-key.pem \
  -config=front-proxy-ca-config.json \
  -profile=kubernetes \
  front-proxy-client-csr.json |cfssljson -bare front-proxy-client

openssl genrsa -out sa.key 2048
openssl rsa -in sa.key -pubout -out sa.pub

date
