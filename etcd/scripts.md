
cfssl gencert -initca config/base/ca-csr.json | cfssljson -bare ca -
cfssl print-defaults csr > peer.json
cfssl gencert -ca=certs/base/ca.pem -ca-key=certs/base/ca-key.pem -config=config/base/ca-config.json -profile=peer config/peer/peer.json | cfssljson -bare peer

cfssl print-defaults csr > client.json
cfssl gencert -ca=certs/base/ca.pem -ca-key=certs/base/ca-key.pem -config=config/base/ca-config.json -profile=client config/client/client.json | cfssljson -bare client

cfssl print-defaults csr > server.json
cfssl gencert -ca=certs/base/ca.pem -ca-key=certs/base/ca-key.pem -config=config/base/ca-config.json -profile=server config/server/server.json | cfssljson -bare server

mkdir /etc/etcd/certs/
cp -r certs/* /etc/etcd/certs/
cp etcd.service /etc/systemd/system/
cp etcd.env /etc/etcd/

export ETCDCTL_API=3
etcdctl  --cacert=/etc/etcd/certs/base/ca.pem --cert=/etc/etcd/certs/client/client.pem --key=/etc/etcd/certs/client/client-key.pem  --endpoints=192.168.57.2:2379,192.168.57.3:2379,192.168.57.4:2379 endpoint health



```shell
#!/bin/bash
# Get kubernetes keys from etcd
export ETCDCTL_API=3
keys=`etcdctl  --cacert=/etc/etcd/certs/base/ca.pem --cert=/etc/etcd/certs/client/client.pem --key=/etc/etcd/certs/client/client-key.pem  --endpoints=192.168.57.2:2379,192.168.57.3:2379,192.168.57.4:2379 get /registry --prefix -w json|python -m json.tool|grep key|cut -d ":" -f2|tr -d '"'|tr -d ","`
for x in $keys;do
  echo $x|base64 -d|sort
done

keys=`etcdctl  --cacert=/etc/etcd/certs/base/ca.pem --cert=/etc/etcd/certs/client/client.pem --key=/etc/etcd/certs/client/client-key.pem  --endpoints=192.168.57.2:2379,192.168.57.3:2379,192.168.57.4:2379 get /calico --prefix -w json|python -m json.tool|grep key|cut -d ":" -f2|tr -d '"'|tr -d ","`
for x in $keys;do
  echo $x|base64 -d|sort
done
```
