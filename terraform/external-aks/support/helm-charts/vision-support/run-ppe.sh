## make sure you are connect to ppe aks via right kube config.
#kubectl config use-context eun-ppe-025-sts-externalaks-admin

## ns should be created only once manually.
#kubectl create namespace sts-ppe-vision

## test it using dry run
#helm upgrade --install --values values-ppe.yaml --namespace default vision-support-release . --dry-run
helm upgrade --install --values values-ppe.yaml --namespace default vision-support-release .
