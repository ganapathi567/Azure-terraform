## login to Azure PROD subscription using rootsp
az login --service-principal --username 'c075239a-ee64-4789-9e17-586658785a54' --password 'JVWlImX.jBP8C.Q#' --tenant 'f55b1f7d-7a7f-49e4-9b90-55218aad89f8'
az account set --subscription 9f813689-c99d-4bb7-8f2f-cf48b6b7c046

## create secrets to be used in the jenkins cicd pipeline for all env.
AZURE_KEY_VAULT="eun-ppe-025-sts-pl-kv"

## key-value pairs for dev env.
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-DEV-storage-acount-name --value eundev025stsglobal
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-DEV-storage-acount-key --value vARC1pR0ndN9fyzUz7ffgGdLKros8nxhqaDH8+7qiHHCM1WjIa+kgI+Ahy4lNR0B9J6hzeRcW/ekWdyBA9PW7Q==
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-DEV-rootsp-username --value ebcd994b-5670-41c1-86b3-b9eba79b83ab
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-DEV-rootsp-password --value 8D#R4WjlqlH!eOCD
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-DEV-az-sub-id --value 9b5ef196-6cf0-4c6c-bea7-68dc747ee888
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-DEV-acr --value eundev025stscontainerregistry
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-DEV-internalaks --value eun-dev-025-sts-internalaks
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-DEV-recon-namespace --value sts-dev-recon
az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-DEV-jobs-namespace --value sts-dev-jobs

## key-value pairs for ppe env.
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-PPE-storage-acount-name --value eundev025stsglobal
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-PPE-storage-acount-key --value vARC1pR0ndN9fyzUz7ffgGdLKros8nxhqaDH8+7qiHHCM1WjIa+kgI+Ahy4lNR0B9J6hzeRcW/ekWdyBA9PW7Q==
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-PPE-rootsp-username --value c075239a-ee64-4789-9e17-586658785a54
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-PPE-rootsp-password --value JVWlImX.jBP8C.Q#
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-PPE-az-sub-id --value 9f813689-c99d-4bb7-8f2f-cf48b6b7c046
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-PPE-acr --value eunppe025stscontainerregistry
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-PPE-internalaks --value eun-ppe-025-sts-internalaks
#az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-PPE-recon-namespace --value sts-ppe-recon
az keyvault secret set --vault-name $AZURE_KEY_VAULT --name STS-PPE-jobs-namespace --value sts-ppe-jobs
