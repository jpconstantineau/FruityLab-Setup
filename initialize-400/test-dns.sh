export KUBECONFIG=$(pwd)/../assets/k3s.yaml

kubectl -n kube-system get pods -l k8s-app=kube-dns

kubectl -n kube-system get svc -l k8s-app=kube-dns

kubectl run -it --rm --restart=Never busybox --image=busybox:1.28 -- nslookup kubernetes.default

kubectl run -it --rm --restart=Never busybox --image=busybox:1.28 -- nslookup www.google.com

kubectl -n kube-system logs -l k8s-app=kube-dns

kubectl -n kube-system get configmap coredns -o go-template={{.data.Corefile}}

kubectl run -i --restart=Never --rm test-${RANDOM} --image=ubuntu --overrides='{"kind":"Pod", "apiVersion":"v1", "spec": {"dnsPolicy":"Default"}}' -- sh -c 'cat /etc/resolv.conf'

