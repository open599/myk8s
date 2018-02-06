1. deploy etcd ,enable tls# myk8s


I'm getting totally opposite error: failed to create kubelet: misconfiguration: kubelet cgroup driver: "systemd" is different from docker cgroup driver: "cgroupfs"

-- Fixed. added "--exec-opt native.cgroupdriver=systemd" to docker options.

kubelet   --cgroup-driver=systemd 

 disable selinux

 yum install iptables

swapoff -a 或者注释 fstab


mkdir /var/lib/kubelet


error: failed to run Kubelet: cannot create certificate signing request: certificatesigningrequests.certificates.k8s.io is forbidden: User "kubelet-bootstrap" cannot create certificatesigningrequests.certificates.k8s.io at the cluster scope
$ kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --user=kubelet-bootstrap

tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://vfpzcerd.mirror.aliyuncs.com"]
}