#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source ./env.sh
echo "${KUBE_APISERVER_IP}"
echo "${ETCD_IP_LIST[@]}"
echo "${LOG_LEVEL}"

mkdir -p artifact/kubernetes/kube-apiserver

cd artifact/kubernetes/kube-apiserver

cat <<EOF >kube-apiserver-csr.json
{
  "CN": "kube-apiserver",
  "hosts": [
    "10.0.0.1",
    "10.96.0.1",
    "127.0.0.1",
    "${KUBE_APISERVER_IP}",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
  ],
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
  ]
}
EOF

cfssl gencert \
  -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes \
  kube-apiserver-csr.json |cfssljson -bare kube-apiserver

ETCD_SERVERS=""
for ETCD_IP in "${ETCD_IP_LIST[@]}"; do
  ETCD_SERVERS="${ETCD_SERVERS},https://${ETCD_IP}:2379"
done
ETCD_SERVERS="$(echo "${ETCD_SERVERS}" |sed "s/^,//g")"

cat <<EOF >kube-apiserver.conf
KUBE_APISERVER_OPTS=" \\
  --advertise-address=${KUBE_APISERVER_IP} \\
  --allow-privileged=true \\
  --authorization-mode=Node,RBAC \\
  --client-ca-file=/opt/kubernetes/ca.pem \\
  --enable-admission-plugins=NodeRestriction \\
  --enable-bootstrap-token-auth=true \\
  --etcd-cafile=/opt/etcd/ca.pem \\
  --etcd-certfile=/opt/etcd/server.pem \\
  --etcd-keyfile=/opt/etcd/server-key.pem \\
  --etcd-servers=${ETCD_SERVERS} \\
  --kubelet-client-certificate=/opt/kubernetes/kube-apiserver/kube-apiserver.pem \\
  --kubelet-client-key=/opt/kubernetes/kube-apiserver/kube-apiserver-key.pem \\
  --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname \\
  --proxy-client-cert-file=/opt/kubernetes/front-proxy-client.pem \\
  --proxy-client-key-file=/opt/kubernetes/front-proxy-client-key.pem \\
  --requestheader-allowed-names=front-proxy-client \\
  --requestheader-client-ca-file=/opt/kubernetes/front-proxy-ca.pem \\
  --requestheader-extra-headers-prefix=X-Remote-Extra- \\
  --requestheader-group-headers=X-Remote-Group \\
  --requestheader-username-headers=X-Remote-User \\
  --secure-port=6443 \\
  --service-account-issuer=https://kubernetes.default.svc.cluster.local \\
  --service-account-key-file=/opt/kubernetes/sa.pub \\
  --service-account-signing-key-file=/opt/kubernetes/sa.key \\
  --service-cluster-ip-range=10.96.0.0/12 \\
  --tls-cert-file=/opt/kubernetes/kube-apiserver/kube-apiserver.pem \\
  --tls-private-key-file=/opt/kubernetes/kube-apiserver/kube-apiserver-key.pem \\
  --v=${LOG_LEVEL} \\
"
EOF

cat <<\EOF >kube-apiserver.service
[Unit]
Description=Kubernetes kube-apiserver
Documentation=https://kubernetes.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
EnvironmentFile=/opt/kubernetes/kube-apiserver/kube-apiserver.conf
ExecStart=/opt/kubernetes/kube-apiserver/kube-apiserver $KUBE_APISERVER_OPTS
Restart=always

[Install]
WantedBy=multi-user.target
EOF

date
