export GITHUB_TOKEN=$(cat ../assets/gh | grep token | awk '{print $2}')
export KUBECONFIG=../assets/kubectl.yaml

 flux bootstrap github --owner=jpconstantineau --repository=flux-homelab --private=true --personal=true --path infrastructure