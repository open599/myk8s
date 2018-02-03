
cfssl gencert -initca config/base/ca-csr.json | cfssljson -bare ca -
cfssl print-defaults csr > peer.json
cfssl gencert -ca=certs/base/ca.pem -ca-key=certs/base/ca-key.pem -config=config/base/ca-config.json -profile=peer config/peer/peer.json | cfssljson -bare peer

cfssl print-defaults csr > client.json
cfssl gencert -ca=certs/base/ca.pem -ca-key=certs/base/ca-key.pem -config=config/base/ca-config.json -profile=client config/client/client.json | cfssljson -bare client
