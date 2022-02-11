export GITHUB_TOKEN=$(cat ../assets/gh | grep token | awk '{print $2}')
export KUBECONFIG=../assets/k3s-production.yaml

 flux bootstrap github --network-policy=false --owner=jpconstantineau --repository=flux-homelab --private=true --personal=true --path infrastructure-infrastructure-development