#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source ./env.sh
echo "${KUBE_APISERVER_IP}"
echo "${CONTAINER_RUNTIME}"
echo "${LOG_LEVEL}"

mkdir -p artifact/kubernetes/kubelet

cd artifact/kubernetes/kubelet

KUBECONFIG="./kubelet-bootstrap.kubeconfig"
KUBE_APISERVER="https://${KUBE_APISERVER_IP}:6443"
[ -f "$KUBECONFIG" ] && rm -f "$KUBECONFIG"
kubectl config set-cluster WHATEVER_CLUSTER_NAME \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG" \
  --server="${KUBE_APISERVER}"
kubectl config set-credentials WHATEVER_USER_NAME \
  --kubeconfig="$KUBECONFIG" \
  --token=abcdef.0123456789abcdef
kubectl config set-context WHATEVER_CONTEXT_NAME \
  --cluster=WHATEVER_CLUSTER_NAME \
  --kubeconfig="$KUBECONFIG" \
  --user=WHATEVER_USER_NAME
kubectl config use-context WHATEVER_CONTEXT_NAME --kubeconfig="$KUBECONFIG"

cat <<EOF >kubelet-config.yml
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 0s
    enabled: true
  x509:
    clientCAFile: /opt/kubernetes/ca.pem
authorization:
  mode: Webhook
  webhook:
    cacheAuthorizedTTL: 0s
    cacheUnauthorizedTTL: 0s
cgroupDriver: systemd
clusterDNS:
- 10.96.0.10
clusterDomain: cluster.local
containerRuntimeEndpoint: ""
cpuManagerReconcilePeriod: 0s
evictionPressureTransitionPeriod: 0s
fileCheckFrequency: 0s
healthzBindAddress: 127.0.0.1
healthzPort: 10248
httpCheckFrequency: 0s
imageMaximumGCAge: 0s
imageMinimumGCAge: 0s
kind: KubeletConfiguration
logging:
  flushFrequency: 0
  options:
    json:
      infoBufferSize: "0"
    text:
      infoBufferSize: "0"
  verbosity: 0
memorySwap: {}
nodeStatusReportFrequency: 0s
nodeStatusUpdateFrequency: 0s
rotateCertificates: true
runtimeRequestTimeout: 0s
shutdownGracePeriod: 0s
shutdownGracePeriodCriticalPods: 0s
staticPodPath: /opt/kubernetes/manifests
streamingConnectionIdleTimeout: 0s
syncFrequency: 0s
volumeStatsAggPeriod: 0s
EOF

if [ "${CONTAINER_RUNTIME}" = "containerd" ]; then
  CONTAINER_RUNTIME_ENDPOINT="unix:///var/run/containerd/containerd.sock"
fi
if [ "${CONTAINER_RUNTIME}" = "crio" ]; then
  CONTAINER_RUNTIME_ENDPOINT="unix:///var/run/crio/crio.sock"
fi
if [ "${CONTAINER_RUNTIME}" = "docker" ]; then
  CONTAINER_RUNTIME_ENDPOINT="unix:///var/run/cri-dockerd.sock"
fi

cat <<EOF >kubelet.conf
KUBELET_OPTS=" \\
  --bootstrap-kubeconfig=/opt/kubernetes/kubelet/kubelet-bootstrap.kubeconfig \\
  --config=/opt/kubernetes/kubelet/kubelet-config.yml \\
  --container-runtime-endpoint=${CONTAINER_RUNTIME_ENDPOINT} \\
  --kubeconfig=/opt/kubernetes/kubelet/kubelet.kubeconfig \\
  --pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.10 \\
  --v=${LOG_LEVEL} \\
"
EOF

cat <<\EOF >kubelet.service
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/
Wants=network-online.target
After=network-online.target containerd.service cri-docker.service

[Service]
EnvironmentFile=/opt/kubernetes/kubelet/kubelet.conf
ExecStart=/opt/kubernetes/kubelet/kubelet $KUBELET_OPTS
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

date
