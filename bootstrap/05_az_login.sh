#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# set the working directory
cd ${SCRIPT_DIR}/../variables

# source proper environment variables
. ${1?:"Usage: ./05_az_login.sh <dev|dev-euw|ppe|prod>"}.sh

# login the current user to do some queries to be able to log in with the service principal
az login
az account set -s ${AZURE_SUBSCRIPTION_NAME}

# WARNING: the user name is the appId and not the objectId
root_sp_user_name=`az ad sp list -o tsv --all --query "[?displayName=='${AZ_SP_PIPELINE}'].appId"`

# source the pipeline password from the configured key-vault
. read_keyvault.sh ${PIPELINE_VAULT_NAME}

# lookup the pipeline user's password from the sourced environment variables
sp_secret_env_variable_name=`echo ${AZ_SP_PIPELINE} | tr '-' '_'`
root_sp_user_password=${!sp_secret_env_variable_name}

az login --service-principal \
    -u ${root_sp_user_name} \
    -p ${root_sp_user_password} \
    -t "f55b1f7d-7a7f-49e4-9b90-55218aad89f8"

#echo "az login --service-principal -u ${root_sp_user_name} -p ${root_sp_user_password} -t ""f55b1f7d-7a7f-49e4-9b90-55218aad89f8"""