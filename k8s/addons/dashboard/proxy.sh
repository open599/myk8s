kubectl proxy --address='0.0.0.0' --accept-hosts='^*$'


http://192.168.57.3:8086/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard/#/workload?namespace=default
http://192.168.57.3:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
