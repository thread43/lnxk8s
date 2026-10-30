C:\k\kubelet.exe --container-runtime-endpoint=npipe:////./pipe/containerd-containerd --pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.10 --cert-dir=c:\var\lib\kubelet\pki --config=/var/lib/kubelet/kubelet-config.yml --bootstrap-kubeconfig=/etc/kubernetes/kubelet-bootstrap.kubeconfig --kubeconfig=/etc/kubernetes/kubelet.kubeconfig --enable-debugging-handlers --cgroups-per-qos=false --enforce-node-allocatable="" --resolv-conf=""

C:\k\kubelet.exe
  --container-runtime-endpoint=npipe:////./pipe/containerd-containerd
  --pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.10
  --cert-dir=c:\var\lib\kubelet\pki
  --config=/var/lib/kubelet/kubelet-config.yml
  --bootstrap-kubeconfig=/etc/kubernetes/kubelet-bootstrap.kubeconfig
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig
  --enable-debugging-handlers
  --cgroups-per-qos=false
  --enforce-node-allocatable=""
  --resolv-conf=""

C:\k\kube-proxy.exe --config=C:\k\kube-proxy-config.yml --v=2
