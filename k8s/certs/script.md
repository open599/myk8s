cfssl gencert -initca ca-csr.json | cfssljson -bare ca

mkdir -p /etc/kubernetes/ssl

cp ca* /etc/kubernetes/ssl

 cfssl gencert -ca=/etc/kubernetes/ssl/ca.pem \
  -ca-key=/etc/kubernetes/ssl/ca-key.pem \
  -config=/etc/kubernetes/ssl/ca-config.json \
  -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes

cfssl gencert -ca=/etc/kubernetes/ssl/ca.pem \
  -ca-key=/etc/kubernetes/ssl/ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes admin-csr.json | cfssljson -bare admin