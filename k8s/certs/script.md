cfssl gencert -initca ca-csr.json | cfssljson -bare ca

mkdir -p /etc/kubernetes/ssl

cp ca* /etc/kubernetes/ssl
