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