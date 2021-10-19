#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# set the working directory
cd ${SCRIPT_DIR}/../variables

# source proper environment variables
. ${1?:"Usage: ./04_pipeline_keyvault.sh <dev|dev-euw|ppe|prod>"}.sh

az group create -l ${AZURE_LOCATION} -n ${PIPELINE_RESOURCE_GROUP}

# the key vault has a soft-delete protection, to permanently delete a keyvault use the following command
# az keyvault delete -n ${PIPELINE_VAULT_NAME}
# az keyvault purge -n ${PIPELINE_VAULT_NAME} -l ${AZURE_LOCATION}
az keyvault create -n "${PIPELINE_VAULT_NAME}" -g "${PIPELINE_RESOURCE_GROUP}"

read -p 'Client secret: ' client_secret

az keyvault secret set -n "${AZ_SP_PIPELINE}" --value "${client_secret}" --vault-name "${PIPELINE_VAULT_NAME}"

rootSpAppId=$(az ad sp list -o tsv --all --query "[?displayName=='${AZ_SP_PIPELINE}'].appId")
keyvaultId=$(az keyvault list -o tsv --query "[?name=='${PIPELINE_VAULT_NAME}'].id")
az role assignment create \
  --role "Reader" \
  --scope "${keyvaultId}" \
  --assignee "${rootSpAppId}"

# WARNING: this is not the same objectId as the one shown in the UI's App Registrations | Overview pane
rootSpObjectId=$(az ad sp list -o tsv --all --query "[?displayName=='${AZ_SP_PIPELINE}'].objectId")
for userObjectId in "${rootSpObjectId}" "25771ac6-e4bf-42f3-8fc7-44851671bf8a" "96bf77e5-7920-4383-8880-a830db3a186f" "d2d419f4-9ef3-4ce2-a81b-44d9e755605c"
do
  az keyvault set-policy \
    --name ${PIPELINE_VAULT_NAME} \
    --object-id "${userObjectId}" \
    --secret-permissions get set list
done
