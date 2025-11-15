#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/cni-plugins

cd pkg

[ -d cni-plugins-linux-amd64-v1.5.1 ] && rm -rf cni-plugins-linux-amd64-v1.5.1
mkdir -p cni-plugins-linux-amd64-v1.5.1
tar xzf cni-plugins-linux-amd64-v1.5.1.tgz -C cni-plugins-linux-amd64-v1.5.1

chown -R root:root cni-plugins-linux-amd64-v1.5.1

chmod +x cni-plugins-linux-amd64-v1.5.1/bandwidth
chmod +x cni-plugins-linux-amd64-v1.5.1/bridge
chmod +x cni-plugins-linux-amd64-v1.5.1/dhcp
chmod +x cni-plugins-linux-amd64-v1.5.1/dummy
chmod +x cni-plugins-linux-amd64-v1.5.1/firewall
chmod +x cni-plugins-linux-amd64-v1.5.1/host-device
chmod +x cni-plugins-linux-amd64-v1.5.1/host-local
chmod +x cni-plugins-linux-amd64-v1.5.1/ipvlan
chmod +x cni-plugins-linux-amd64-v1.5.1/loopback
chmod +x cni-plugins-linux-amd64-v1.5.1/macvlan
chmod +x cni-plugins-linux-amd64-v1.5.1/portmap
chmod +x cni-plugins-linux-amd64-v1.5.1/ptp
chmod +x cni-plugins-linux-amd64-v1.5.1/sbr
chmod +x cni-plugins-linux-amd64-v1.5.1/static
chmod +x cni-plugins-linux-amd64-v1.5.1/tuning
chmod +x cni-plugins-linux-amd64-v1.5.1/vlan
chmod +x cni-plugins-linux-amd64-v1.5.1/vrf

cp -a cni-plugins-linux-amd64-v1.5.1/bandwidth   ../artifact/cni-plugins/bandwidth
cp -a cni-plugins-linux-amd64-v1.5.1/bridge      ../artifact/cni-plugins/bridge
cp -a cni-plugins-linux-amd64-v1.5.1/dhcp        ../artifact/cni-plugins/dhcp
cp -a cni-plugins-linux-amd64-v1.5.1/dummy       ../artifact/cni-plugins/dummy
cp -a cni-plugins-linux-amd64-v1.5.1/firewall    ../artifact/cni-plugins/firewall
cp -a cni-plugins-linux-amd64-v1.5.1/host-device ../artifact/cni-plugins/host-device
cp -a cni-plugins-linux-amd64-v1.5.1/host-local  ../artifact/cni-plugins/host-local
cp -a cni-plugins-linux-amd64-v1.5.1/ipvlan      ../artifact/cni-plugins/ipvlan
cp -a cni-plugins-linux-amd64-v1.5.1/loopback    ../artifact/cni-plugins/loopback
cp -a cni-plugins-linux-amd64-v1.5.1/macvlan     ../artifact/cni-plugins/macvlan
cp -a cni-plugins-linux-amd64-v1.5.1/portmap     ../artifact/cni-plugins/portmap
cp -a cni-plugins-linux-amd64-v1.5.1/ptp         ../artifact/cni-plugins/ptp
cp -a cni-plugins-linux-amd64-v1.5.1/sbr         ../artifact/cni-plugins/sbr
cp -a cni-plugins-linux-amd64-v1.5.1/static      ../artifact/cni-plugins/static
cp -a cni-plugins-linux-amd64-v1.5.1/tuning      ../artifact/cni-plugins/tuning
cp -a cni-plugins-linux-amd64-v1.5.1/vlan        ../artifact/cni-plugins/vlan
cp -a cni-plugins-linux-amd64-v1.5.1/vrf         ../artifact/cni-plugins/vrf

date
