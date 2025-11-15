lnxk8s - bootstrap a kubernetes cluster from scratch in 5 minutes



-- requirement
2c2g at least
2c4g or 2c2g*2 would be better



-- usage
vim env.sh
bash bootstrap.sh
bash uninstall.sh



-- upstream
kubernetes     v1.31.14 https://github.com/kubernetes/kubernetes
etcd           v3.5.24  https://github.com/etcd-io/etcd
cni-plugins    v1.5.1   https://github.com/containernetworking/plugins
coredns        v1.11.3  https://github.com/kubernetes/kubernetes/tree/v1.31.14/cluster/addons/dns/coredns
runc           v1.3.3   https://github.com/opencontainers/runc
containerd     v1.7.29  https://github.com/containerd/containerd
crictl         v1.33.0  https://github.com/kubernetes-sigs/cri-tools
docker         v28.1.1  https://github.com/moby/moby
cri-dockerd    v0.3.17  https://github.com/Mirantis/cri-dockerd
crio           v1.30.12 https://github.com/cri-o/cri-o
flannel        v0.27.4  https://github.com/flannel-io/flannel
calico         v3.30.0  https://github.com/projectcalico/calico
cilium         v1.17.4  https://github.com/cilium/cilium
cfssl          v1.6.5   https://github.com/cloudflare/cfssl
metrics-server v0.8.0   https://github.com/kubernetes-sigs/metrics-server
dashboard      v7.12.0  https://github.com/kubernetes/dashboard



-- big picture
bootstrap.sh
|-- init.sh
|   |-- init_ssh.sh
|   `-- init_check.sh
|-- download.sh
|   |-- download_cfssl.sh
|   |-- download_etcd.sh
|   |-- download_cni_plugins.sh
|   |-- download_containerd.sh
|   |-- download_runc.sh
|   |-- download_crictl.sh
|   |-- download_crio.sh
|   |-- download_docker.sh
|   |-- download_cri_dockerd.sh
|   `-- download_kubernetes.sh
|-- unpkg.sh
|   |-- unpkg_cfssl.sh
|   |-- unpkg_etcd.sh
|   |-- unpkg_cni_plugins.sh
|   |-- unpkg_containerd.sh
|   |-- unpkg_runc.sh
|   |-- unpkg_crictl.sh
|   |-- unpkg_crio.sh
|   |-- unpkg_docker.sh
|   |-- unpkg_cri_dockerd.sh
|   `-- unpkg_kubernetes.sh
|-- make.sh
|   |-- make_etcd.sh
|   |-- make_containerd.sh
|   |-- make_crictl.sh
|   |-- make_crio.sh
|   |-- make_docker.sh
|   |-- make_cri_dockerd.sh
|   |-- make_kubernetes_common.sh
|   |-- make_kubernetes_kubectl.sh
|   |-- make_kubernetes_kube_apiserver.sh
|   |-- make_kubernetes_kube_controller_manager.sh
|   |-- make_kubernetes_kube_scheduler.sh
|   |-- make_kubernetes_kubelet.sh
|   `-- make_kubernetes_kube_proxy.sh
|-- stage.sh
|   |-- stage_etcd.sh
|   |-- stage_cni_plugins.sh
|   |-- stage_containerd.sh
|   |-- stage_runc.sh
|   |-- stage_crictl.sh
|   |-- stage_crio.sh
|   |-- stage_docker.sh
|   |-- stage_cri_dockerd.sh
|   |-- stage_kubectl.sh
|   |-- stage_kubernetes_common.sh
|   |-- stage_kubernetes_kubectl.sh
|   |-- stage_kubernetes_kube_apiserver.sh
|   |-- stage_kubernetes_kube_controller_manager.sh
|   |-- stage_kubernetes_kube_scheduler.sh
|   |-- stage_kubernetes_kubelet.sh
|   `-- stage_kubernetes_kube_proxy.sh
|-- distribute.sh
|-- install.sh
|   |-- install_kubectl.sh
|   |-- install_etcd.sh
|   |-- install_kubernetes_master.sh
|   |   |-- install_kubernetes_common.sh
|   |   |-- install_kubernetes_kubectl.sh
|   |   |-- install_kubernetes_kube_apiserver.sh
|   |   |-- install_kubernetes_kube_controller_manager.sh
|   |   `-- install_kubernetes_kube_scheduler.sh
|   |-- install_kubernetes_worker.sh
|   |   |-- install_cni_plugins.sh
|   |   |-- install_containerd.sh
|   |   |-- install_runc.sh
|   |   |-- install_crictl.sh
|   |   |-- install_crio.sh
|   |   |-- install_docker.sh
|   |   |-- install_cri_dockerd.sh
|   |   |-- install_kubernetes_common.sh
|   |   |-- install_kubernetes_kubelet.sh
|   |   `-- install_kubernetes_kube_proxy.sh
|   |-- addon/coredns/install_coredns.sh
|   |-- addon/metrics_server/install_metrics_server.sh
|   |-- addon/flannel/install_flannel.sh
|   |-- addon/calico/install_calico.sh
|   `-- addon/cilium/install_cilium.sh
`-- setup.sh
