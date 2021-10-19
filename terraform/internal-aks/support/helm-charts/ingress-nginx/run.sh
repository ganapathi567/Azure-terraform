## refer - https://docs.microsoft.com/en-us/azure/aks/ingress-internal-ip

# Create a namespace for your ingress resources
kubectl create namespace ingress-nginx

# Add the ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Use Helm to deploy an NGINX ingress controller
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    -f internal-ingress.yaml \
    --set controller.replicaCount=3 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux