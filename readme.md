1. deploy etcd ,enable tls# myk8s


I'm getting totally opposite error: failed to create kubelet: misconfiguration: kubelet cgroup driver: "systemd" is different from docker cgroup driver: "cgroupfs"

-- Fixed. added "--exec-opt native.cgroupdriver=systemd" to docker options.