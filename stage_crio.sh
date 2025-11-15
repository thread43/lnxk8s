#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact

cd artifact

cat <<\EOF >install_crio.sh
#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p /etc/cni/net.d
mkdir -p /etc/containers/registries.conf.d
mkdir -p /etc/crio
mkdir -p /etc/crio/crio.conf.d
mkdir -p /usr/local/share/oci-umount/oci-umount.d

cp -a crio/10-crio.conf                 /etc/crio/crio.conf.d/10-crio.conf
cp -a crio/11-crio-ipv4-bridge.conflist /etc/cni/net.d/11-crio-ipv4-bridge.conflist
cp -a crio/conmon                       /usr/local/bin/conmon
cp -a crio/conmonrs                     /usr/local/bin/conmonrs
cp -a crio/crictl                       /usr/local/bin/crictl
cp -a crio/crictl.yaml                  /etc/crictl.yaml
cp -a crio/crio                         /usr/local/bin/crio
cp -a crio/crio-umount.conf             /usr/local/share/oci-umount/oci-umount.d/crio-umount.conf
cp -a crio/crio.service                 /usr/lib/systemd/system/crio.service
cp -a crio/crun                         /usr/local/bin/crun
cp -a crio/pinns                        /usr/local/bin/pinns
cp -a crio/policy.json                  /etc/crio/policy.json
cp -a crio/registries.conf              /etc/containers/registries.conf.d/registries.conf
cp -a crio/runc                         /usr/local/bin/runc

systemctl daemon-reload
systemctl enable crio
systemctl restart crio

date
EOF

date
