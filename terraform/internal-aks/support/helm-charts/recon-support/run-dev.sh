## make sure you are connect to dev aks via right kube config.
#kubectl config use-context eun-dev-025-sts-internalaks-admin

## ns should be created only once manually.
#kubectl create namespace sts-dev-recon

## test it using dry run
#helm upgrade --install --values values-dev.yaml --namespace default recon-support-release . --dry-run
helm upgrade --install --values values-dev.yaml --namespace default recon-support-release .
