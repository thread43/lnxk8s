#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source ./env.sh
echo "${KUBE_APISERVER_IP}"
echo "${KUBE_PROXY_MODE}"
echo "${LOG_LEVEL}"

mkdir -p artifact/kubernetes/kube-proxy

cd artifact/kubernetes/kube-proxy

cat <<EOF >kube-proxy-csr.json
{
  "CN": "system:kube-proxy",
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
  kube-proxy-csr.json |cfssljson -bare kube-proxy

KUBECONFIG="./kube-proxy.kubeconfig"
KUBE_APISERVER="https://${KUBE_APISERVER_IP}:6443"
[ -f "$KUBECONFIG" ] && rm -f "$KUBECONFIG"
kubectl config set-cluster WHATEVER_CLUSTER_NAME \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG" \
  --server="${KUBE_APISERVER}"
kubectl config set-credentials WHATEVER_USER_NAME \
  --client-certificate=./kube-proxy.pem \
  --client-key=./kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG"
kubectl config set-context WHATEVER_CONTEXT_NAME \
  --cluster=WHATEVER_CLUSTER_NAME \
  --kubeconfig="$KUBECONFIG" \
  --user=WHATEVER_USER_NAME
kubectl config use-context WHATEVER_CONTEXT_NAME --kubeconfig="$KUBECONFIG"

cat <<EOF >kube-proxy-config.yml
apiVersion: kubeproxy.config.k8s.io/v1alpha1
bindAddress: 0.0.0.0
bindAddressHardFail: false
clientConnection:
  acceptContentTypes: ""
  burst: 0
  contentType: ""
  kubeconfig: /opt/kubernetes/kube-proxy/kube-proxy.kubeconfig
  qps: 0
clusterCIDR: 10.244.0.0/16
configSyncPeriod: 0s
conntrack:
  maxPerCore: null
  min: null
  tcpBeLiberal: false
  tcpCloseWaitTimeout: null
  tcpEstablishedTimeout: null
  udpStreamTimeout: 0s
  udpTimeout: 0s
detectLocal:
  bridgeInterface: ""
  interfaceNamePrefix: ""
detectLocalMode: ""
enableProfiling: false
healthzBindAddress: ""
hostnameOverride: ""
iptables:
  localhostNodePorts: null
  masqueradeAll: false
  masqueradeBit: null
  minSyncPeriod: 0s
  syncPeriod: 0s
ipvs:
  excludeCIDRs: null
  minSyncPeriod: 0s
  scheduler: ""
  strictARP: false
  syncPeriod: 0s
  tcpFinTimeout: 0s
  tcpTimeout: 0s
  udpTimeout: 0s
kind: KubeProxyConfiguration
logging:
  flushFrequency: 0
  options:
    json:
      infoBufferSize: "0"
    text:
      infoBufferSize: "0"
  verbosity: 0
metricsBindAddress: ""
mode: "${KUBE_PROXY_MODE}"
nftables:
  masqueradeAll: false
  masqueradeBit: null
  minSyncPeriod: 0s
  syncPeriod: 0s
nodePortAddresses: null
oomScoreAdj: null
portRange: ""
showHiddenMetricsForVersion: ""
winkernel:
  enableDSR: false
  forwardHealthCheckVip: false
  networkName: ""
  rootHnsEndpointName: ""
  sourceVip: ""
EOF

cat <<EOF >kube-proxy.conf
KUBE_PROXY_OPTS=" \\
  --config=/opt/kubernetes/kube-proxy/kube-proxy-config.yml \\
  --v=${LOG_LEVEL} \\
"
EOF

cat <<\EOF >kube-proxy.service
[Unit]
Description=Kubernetes kube-proxy
Documentation=https://kubernetes.io/docs/
Wants=network-online.target
After=network-online.target containerd.service cri-docker.service docker.service

[Service]
EnvironmentFile=/opt/kubernetes/kube-proxy/kube-proxy.conf
ExecStart=/opt/kubernetes/kube-proxy/kube-proxy $KUBE_PROXY_OPTS
Restart=always

[Install]
WantedBy=multi-user.target
EOF

date
