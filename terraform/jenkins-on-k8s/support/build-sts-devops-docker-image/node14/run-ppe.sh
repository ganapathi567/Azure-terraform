## Caution: Whenever modifying the sts devops docker image, consider bumping up the version instead of altering the existing version.

DOCKER_TAG=node14-v001

## build new docker image and tag it
docker build -t eunppe025stscontainerregistry.azurecr.io/stsdevops/cicd-build-agent:$DOCKER_TAG .

## login to Azure PROD subscription using rootsp
az login --service-principal --username 'c075239a-ee64-4789-9e17-586658785a54' --password 'JVWlImX.jBP8C.Q#' --tenant 'f55b1f7d-7a7f-49e4-9b90-55218aad89f8'
az account set --subscription 9f813689-c99d-4bb7-8f2f-cf48b6b7c046

## login to Az ACR
az acr login -n eunppe025stscontainerregistry

## push tagged docker image to Az ACR
docker push eunppe025stscontainerregistry.azurecr.io/stsdevops/cicd-build-agent:$DOCKER_TAG