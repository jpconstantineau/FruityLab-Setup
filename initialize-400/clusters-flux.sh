export GITHUB_TOKEN=$(cat ../assets/gh | grep token | awk '{print $2}')
export KUBECONFIG=../assets/kubectl.yaml


 flux create kustomization --source flux-system --path "./cluster/internal/" --prune true --validation client \
  --export | tee -a ../../flux-homelab/infrastructure/internal.yaml

  flux create kustomization --source flux-system --path "./cluster/external/" --prune true --validation client \
  --export | tee -a ../../flux-homelab/infrastructure/external.yaml