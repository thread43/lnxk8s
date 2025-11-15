#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact/crio

cd artifact/crio

cat <<EOF >10-crio.conf
[crio.image]
signature_policy = "/etc/crio/policy.json"

[crio.runtime]
default_runtime = "crun"

[crio.runtime.runtimes.crun]
runtime_path = "/usr/local/bin/crun"
runtime_root = "/run/crun"
monitor_path = "/usr/local/bin/conmon"
allowed_annotations = [
    "io.containers.trace-syscall",
]

[crio.runtime.runtimes.runc]
runtime_path = "/usr/local/bin/runc"
runtime_root = "/run/runc"
monitor_path = "/usr/local/bin/conmon"
EOF

cat <<EOF >policy.json
{ "default": [{ "type": "insecureAcceptAnything" }] }
EOF

cat <<EOF >registries.conf
unqualified-search-registries = ["docker.io", "quay.io"]

[[registry]]
location = "registry.k8s.io"

[[registry.mirror]]
location = "registry.aliyuncs.com/google_containers"
EOF

cat <<EOF >11-crio-ipv4-bridge.conflist
{
  "cniVersion": "1.0.0",
  "name": "crio",
  "plugins": [
    {
      "type": "bridge",
      "bridge": "cni0",
      "isGateway": true,
      "ipMasq": true,
      "hairpinMode": true,
      "ipam": {
        "type": "host-local",
        "routes": [
            { "dst": "0.0.0.0/0" }
        ],
        "ranges": [
            [{ "subnet": "10.85.0.0/16" }]
        ]
      }
    }
  ]
}
EOF

cat <<EOF >crio-umount.conf

/var/run/containers/*
/var/lib/containers/storage/*
EOF

cat <<EOF >crictl.yaml
runtime-endpoint: "unix:///var/run/crio/crio.sock"
timeout: 0
debug: false
EOF

cat <<\EOF >crio.service
[Unit]
Description=Container Runtime Interface for OCI (CRI-O)
Documentation=https://github.com/cri-o/cri-o
Wants=network-online.target
Before=kubelet.service
After=network-online.target

[Service]
Type=notify
EnvironmentFile=-/etc/sysconfig/crio
Environment=GOTRACEBACK=crash
ExecStart=/usr/local/bin/crio \
          $CRIO_CONFIG_OPTIONS \
          $CRIO_RUNTIME_OPTIONS \
          $CRIO_STORAGE_OPTIONS \
          $CRIO_NETWORK_OPTIONS \
          $CRIO_METRICS_OPTIONS
ExecReload=/bin/kill -s HUP $MAINPID
TasksMax=infinity
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=infinity
OOMScoreAdjust=-999
TimeoutStartSec=0
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
Alias=cri-o.service
EOF

date
