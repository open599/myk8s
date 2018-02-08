docker run --privileged --net=host -d                                \
           -e IP=192.168.57.5                                      \
           -e ETCD_ENDPOINTS=https://192.168.57.2:2379,https://192.168.57.3:2379,https://192.168.57.4:2379                \
           -v /etc/etcd/certs:/etc/etcd/certs                  \
           -v $PWD/bird.cfg.template:/templates/bird.cfg.template \
           -e ETCD_CA_CERT_FILE=/etc/etcd/certs/base/ca.pem              \
           -e ETCD_CERT_FILE=/etc/etcd/certs/client/client.pem               \
           -e ETCD_KEY_FILE=/etc/etcd/certs/client/client-key.pem                 \
           calico/routereflector