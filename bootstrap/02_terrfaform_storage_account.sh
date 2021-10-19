#!/bin/bash

set -euo pipefail

# Reference: https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage
# The ACCESS_KEY part is not required as it seems to be an alternative authentication method.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# set the working directory
cd ${SCRIPT_DIR}/../variables

# source proper environment variables
. ${1?:"Usage: ./02_terraform-storage-account.sh <dev|dev-eun|ppe|prod>"}.sh

# Create resource group
az group create --location ${AZURE_LOCATION} --name ${TF_VAR_tf_storage_account_resource_group}

# Create storage account
az storage account create \
    --name ${TF_VAR_tf_storage_account_name} \
    --resource-group ${TF_VAR_tf_storage_account_resource_group} \
    --sku Standard_GRS \
    --encryption-services blob \
    --https-only true \
    --kind BlobStorage \
    --access-tier Cool

# Create blob container
az storage container create \
    --name "terraform-state-${TESCO_TEAM_NAME}" \
    --public-access off \
    --account-name ${TF_VAR_tf_storage_account_name}

