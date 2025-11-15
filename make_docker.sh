#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact/docker

cd artifact/docker

cat <<EOF >daemon.json
{
  "exec-opts": [
    "native.cgroupdriver=systemd"
  ],
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://cagucih8.mirror.aliyuncs.com/"
  ]
}
EOF

cat <<\EOF >docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target docker.socket firewalld.service containerd.service time-set.target
Wants=network-online.target containerd.service

[Service]
Type=notify
ExecStart=/usr/local/bin/dockerd
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always

StartLimitBurst=3

StartLimitInterval=60s

LimitNPROC=infinity
LimitCORE=infinity
LimitNOFILE=1024:524288

TasksMax=infinity

Delegate=yes

KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

date
