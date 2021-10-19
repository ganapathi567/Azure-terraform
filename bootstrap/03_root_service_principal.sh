#!/bin/bash

environment=${1:?"Usage ./03_root_service_principal.sh <dev|dev-euw|ppe|prod>"}

echo "Set owner_object_ids in root-service-principal/main.tf"
read -p "Press any key to continue... " key

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

TERRAFORM_DIR=${SCRIPT_DIR}/root-service-principal

. ${SCRIPT_DIR}/../variables/_functions.sh
. ${SCRIPT_DIR}/../variables/${environment}.sh

cd ${TERRAFORM_DIR} && terraform_init

cd ${TERRAFORM_DIR} && terraform plan \
  -var="root_service_principal_name=${AZ_SP_PIPELINE}"

cd ${TERRAFORM_DIR} && terraform apply \
  -var="root_service_principal_name=${AZ_SP_PIPELINE}" \
  -auto-approve