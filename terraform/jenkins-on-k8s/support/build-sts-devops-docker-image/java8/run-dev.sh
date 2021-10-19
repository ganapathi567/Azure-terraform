## Caution: Whenever modifying the sts devops docker image, consider bumping up the version instead of altering the existing version.

#DOCKER_TAG=java8-v001
DOCKER_TAG=java8-v002

## build new docker image and tag it
docker build -t eundev025stscontainerregistry.azurecr.io/stsdevops/cicd-build-agent:$DOCKER_TAG .

## login to Azure DEV subscription using rootSP.
az login --service-principal --username 'ebcd994b-5670-41c1-86b3-b9eba79b83ab' --password '8D#R4WjlqlH!eOCD' --tenant 'f55b1f7d-7a7f-49e4-9b90-55218aad89f8'
az account set --subscription 9b5ef196-6cf0-4c6c-bea7-68dc747ee888

## login to Az ACR
az acr login -n eundev025stscontainerregistry

## push tagged docker image to Az ACR
docker push eundev025stscontainerregistry.azurecr.io/stsdevops/cicd-build-agent:$DOCKER_TAG