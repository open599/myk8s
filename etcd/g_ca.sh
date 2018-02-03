
cfssl gencert -initca config/base/ca-csr.json | cfssljson -bare ca -