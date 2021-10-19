## make sure you are connect to dev aks via right kube config.
#kubectl config use-context eun-dev-025-sts-externalaks-admin

## ns should be created only once manually.
#kubectl create namespace sts-dev-vision

## test it using dry run
#helm upgrade --install --values values-dev.yaml --namespace default vision-support-release . --dry-run
helm upgrade --install --values values-dev.yaml --namespace default vision-support-release .
