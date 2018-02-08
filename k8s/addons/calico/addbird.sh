#!/bin/bash
# Get kubernetes keys from etcd
export ETCDCTL_API=3

keys=`etcdctl  --cacert=/etc/etcd/certs/base/ca.pem --cert=/etc/etcd/certs/client/client.pem --key=/etc/etcd/certs/client/client-key.pem  --endpoints=192.168.57.2:2379,192.168.57.3:2379,192.168.57.4:2379 get /calico --prefix -w json|python -m json.tool|grep key|cut -d ":" -f2|tr -d '"'|tr -d ","`
for x in $keys;do
  echo $x|base64 -d|sort
done