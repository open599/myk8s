calicoctl -ldebug get nodes  -c calico.conf  -o wide

### nodeToNodeMesh false

```code
[root@minion2 ~]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.0.2.1        0.0.0.0         UG    100    0        0 enp0s3
10.0.2.0        0.0.0.0         255.255.255.0   U     100    0        0 enp0s3
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
172.30.179.192  0.0.0.0         255.255.255.192 U     0      0        0 *
172.30.179.196  0.0.0.0         255.255.255.255 UH    0      0        0 calif0db6a9ef60
172.30.179.197  0.0.0.0         255.255.255.255 UH    0      0        0 cali2979978fe41
172.30.179.198  0.0.0.0         255.255.255.255 UH    0      0        0 calie0009a25fd1
172.30.179.199  0.0.0.0         255.255.255.255 UH    0      0        0 cali2413786a555
192.168.57.0    0.0.0.0         255.255.255.0   U     100    0        0 enp0s8
[root@minion2 ~]# kubectl get po
NAME                        READY     STATUS    RESTARTS   AGE
busybox                     1/1       Running   4          17h
my-nginx-56b48db847-5r4vs   1/1       Running   2          16h
my-nginx-56b48db847-twkvw   1/1       Running   2          16h
nginx-ds-8q846              1/1       Running   2          17h
nginx-ds-l86wf              1/1       Running   2          17h
[root@minion2 ~]# kubectl get po -o wide
NAME                        READY     STATUS    RESTARTS   AGE       IP               NODE
busybox                     1/1       Running   4          17h       172.30.34.3      192.168.57.3
my-nginx-56b48db847-5r4vs   1/1       Running   2          16h       172.30.34.4      192.168.57.3
my-nginx-56b48db847-twkvw   1/1       Running   2          16h       172.30.179.197   192.168.57.4
nginx-ds-8q846              1/1       Running   2          17h       172.30.34.5      192.168.57.3
nginx-ds-l86wf              1/1       Running   2          17h       172.30.179.196   192.168.57.4
[root@minion2 ~]# ping 172.30.34.4
PING 172.30.34.4 (172.30.34.4) 56(84) bytes of data.
^C
--- 172.30.34.4 ping statistics ---
8 packets transmitted, 0 received, 100% packet loss, time 7000ms

```

### nodeToNodeMesh true

```code
[root@minion2 ~]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.0.2.1        0.0.0.0         UG    100    0        0 enp0s3
10.0.2.0        0.0.0.0         255.255.255.0   U     100    0        0 enp0s3
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
172.30.34.0     192.168.57.3    255.255.255.192 UG    0      0        0 enp0s8
172.30.179.192  0.0.0.0         255.255.255.192 U     0      0        0 *
172.30.179.196  0.0.0.0         255.255.255.255 UH    0      0        0 calif0db6a9ef60
172.30.179.197  0.0.0.0         255.255.255.255 UH    0      0        0 cali2979978fe41
172.30.179.198  0.0.0.0         255.255.255.255 UH    0      0        0 calie0009a25fd1
172.30.179.199  0.0.0.0         255.255.255.255 UH    0      0        0 cali2413786a555
192.168.57.0    0.0.0.0         255.255.255.0   U     100    0        0 enp0s8
[root@minion2 ~]# ping 172.30.34.4
PING 172.30.34.4 (172.30.34.4) 56(84) bytes of data.
64 bytes from 172.30.34.4: icmp_seq=1 ttl=63 time=0.564 ms
64 bytes from 172.30.34.4: icmp_seq=2 ttl=63 time=0.373 ms
^C
--- 172.30.34.4 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.373/0.468/0.564/0.097 ms
```

### routereflector on

#### 部署rr

1. 容器方式  ./rr.sh
2. host方式 bird,并且将路由映射到本地

```
yum install epel-release

yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

yum install -y bird{,6}
```

```

#/etc/bird.conf
# Configure logging
log syslog { debug, trace, info, remote, warning, error, auth, fatal, bug };
log stderr all;

# Override router ID
router id <router_id>; #ip


filter import_kernel {
if ( net != 0.0.0.0/0 ) then {
   accept;
   }
reject;
}

# Turn on global debugging of all protocols
debug protocols all;

# This pseudo-protocol watches all interface up/down events.
protocol device {
  scan time 2;    # Scan interfaces every 2 seconds
}

protocol bgp <node_shortname> {
  description "<node_ip>";
  local as <as_number>;
  neighbor <node_ip> as <as_number>; #需要连接这个rr的client ip
  multihop;
  rr client;
  graceful restart;
  import all;
  export all;
}

```

#### 连接rr
```code

calicoctl apply -f peer.yaml -c calico-config.yaml

[root@minion1 calico]# calicoctl node status
Calico process is running.

IPv4 BGP status
+--------------+-----------+-------+----------+--------+
| PEER ADDRESS | PEER TYPE | STATE |  SINCE   |  INFO  |
+--------------+-----------+-------+----------+--------+
| 192.168.57.5 | global    | start | 08:35:37 | Active |
+--------------+-----------+-------+----------+--------+

[root@minion1 ~]# birdcl -s /var/run/calico/bird.ctl show route
BIRD 1.6.3 ready.
0.0.0.0/0          via 10.0.2.1 on enp0s3 [kernel1 07:09:41] * (10)
10.0.2.0/24        dev enp0s3 [direct1 07:09:41] * (240)
192.168.57.0/24    dev enp0s8 [direct1 07:09:41] * (240)
172.30.179.192/26  via 192.168.57.4 on enp0s8 [Node_192_168_57_5 08:22:08 from 192.168.57.5] * (100/0) [i]
172.30.34.8/32     dev cali6c9ad161b12 [kernel1 07:09:41] * (10)
172.17.0.0/16      dev docker0 [direct1 07:09:41] * (240)
172.30.34.7/32     dev calic39cc9cb4e7 [kernel1 07:09:41] * (10)
172.30.34.6/32     dev cali12d4a061371 [kernel1 07:09:41] * (10)
172.30.34.0/26     blackhole [static1 07:09:41] * (200)
```


```
/calico/ipam/v2/assignment/ipv4/block/172.30.179.192-26
/calico/ipam/v2/assignment/ipv4/block/172.30.34.0-26
/calico/ipam/v2/handle/k8s-pod-network.04cff94076271743f054483af1788f7662b5bdb58d4472472c04c61993431cc2
/calico/ipam/v2/handle/k8s-pod-network.19aba9c953689b0e3d43c26eeec60c59050c7f56dc3a3d3325673edcba42050e
/calico/ipam/v2/handle/k8s-pod-network.30e9d4a28da4750ce05205caf72b3b6d4040b97bccbb186eb48d36144ac20634
/calico/ipam/v2/handle/k8s-pod-network.72c861b862018a6e1b8a6e46b287510ebdec28e4173db93e80a7862394273842
/calico/ipam/v2/handle/k8s-pod-network.b2f58da6645ed058f38c79ef823c6c1e5128b75193630e2823d3da0df389551e
/calico/ipam/v2/handle/k8s-pod-network.bcb242ff44f3e5066ea30c653bb0e547a56045e17b85322805a30e364bf3fc15
/calico/ipam/v2/handle/k8s-pod-network.e7dd0b5d2c0b432ff3309b36e8307b70130daff5346ac270c526cfa9f5e99f51
/calico/ipam/v2/host/minion1/ipv4/block/172.30.34.0-26
/calico/ipam/v2/host/minion2/ipv4/block/172.30.179.192-26
/calico/resources/v3/projectcalico.org/bgpconfigurations/default
/calico/resources/v3/projectcalico.org/bgppeers/peer.minion
/calico/resources/v3/projectcalico.org/clusterinformations/default
/calico/resources/v3/projectcalico.org/felixconfigurations/default
/calico/resources/v3/projectcalico.org/felixconfigurations/node.minion1
/calico/resources/v3/projectcalico.org/felixconfigurations/node.minion2
/calico/resources/v3/projectcalico.org/ippools/default-ipv4-ippool
/calico/resources/v3/projectcalico.org/ippools/default-ipv6-ippool
/calico/resources/v3/projectcalico.org/nodes/minion1
/calico/resources/v3/projectcalico.org/nodes/minion2
/calico/resources/v3/projectcalico.org/profiles/kns.default
/calico/resources/v3/projectcalico.org/profiles/kns.kube-public
/calico/resources/v3/projectcalico.org/profiles/kns.kube-system
/calico/resources/v3/projectcalico.org/workloadendpoints/default/minion1-k8s-busybox-eth0
/calico/resources/v3/projectcalico.org/workloadendpoints/default/minion1-k8s-my--nginx--56b48db847--5r4vs-eth0
/calico/resources/v3/projectcalico.org/workloadendpoints/default/minion1-k8s-nginx--ds--8q846-eth0
/calico/resources/v3/projectcalico.org/workloadendpoints/default/minion2-k8s-my--nginx--56b48db847--twkvw-eth0
/calico/resources/v3/projectcalico.org/workloadendpoints/default/minion2-k8s-nginx--ds--l86wf-eth0
/calico/resources/v3/projectcalico.org/workloadendpoints/kube-system/minion2-k8s-kube--dns--65ddcd8f4--t9n6j-eth0
/calico/resources/v3/projectcalico.org/workloadendpoints/kube-system/minion2-k8s-kubernetes--dashboard--54db87455--cd5zh-eth0
```