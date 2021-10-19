#!/bin/bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# set the working directory
cd ${SCRIPT_DIR}/../variables

# source proper environment variables
. ${1?:"Usage: ./06_stack_keyvault.sh <dev|dev-euw|ppe|prod>"}.sh

az keyvault create -n ${INFRA_VAULT_NAME} -g ${PIPELINE_RESOURCE_GROUP}

# the recover command can fix the situation when a keyvault creation fails
# due to a previous keyvault (with soft delete enabled) delete command
# az keyvault recover -n ${INFRA_VAULT_NAME} -g ${INFRA_VAULT_NAME}

az keyvault secret set -n SPLUNK-HEC-TOKEN           --vault-name ${INFRA_VAULT_NAME} --value somevalue

# If for some reason the SPs need to be deleted then they can be looked up and deleted using the following commands.
#
# az_sp_client_id=`az ad sp list -o tsv --query "[?appDisplayName=='${AZ_SP_CONTRIBUTOR}'].{appId:appId}" --all`
# az ad sp delete --id ${az_sp_client_id}
# az_sp_client_id=`az ad sp list -o tsv --query "[?appDisplayName=='${AZ_SP_READER}'].{appId:appId}" --all`
# az ad sp delete --id ${az_sp_client_id}

createServicePrincipal() {
    local sp_name=$1
    local sp_role=$2
    local subscription_id=$3
    local vault_name=$4

    regex=","

    echo "creating service principal ${sp_name}..."
    AZURE_CLIENT_SECRET=`az ad sp create-for-rbac --name ${sp_name} --role ${sp_role} --query 'password' -o tsv --scopes  /subscriptions/${subscription_id}`

    while [[ ${AZURE_CLIENT_SECRET} =~ ${regex} ]]
      do
        echo "service principal ${sp_name}password ${AZURE_CLIENT_SECRET} contains invalid character, generating a new one..."
        AZURE_CLIENT_SECRET=`az ad sp create-for-rbac --name ${sp_name} --role ${sp_role} --query 'password' -o tsv --scopes  /subscriptions/${subscription_id}`
      done

    az keyvault secret set -n ${sp_name} --value ${AZURE_CLIENT_SECRET} --vault-name ${vault_name}
}

createServicePrincipal ${AZ_SP_CONTRIBUTOR} "Contributor" ${AZURE_SUBSCRIPTION_ID} ${INFRA_VAULT_NAME}
createServicePrincipal ${AZ_SP_READER} "Reader" ${AZURE_SUBSCRIPTION_ID} ${INFRA_VAULT_NAME}
