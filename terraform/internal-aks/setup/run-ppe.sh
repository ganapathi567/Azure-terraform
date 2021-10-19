#!/bin/bash

export ARM_CLIENT_ID="c075239a-ee64-4789-9e17-586658785a54"
export ARM_CLIENT_SECRET='JVWlImX.jBP8C.Q#'
export ARM_TENANT_ID="f55b1f7d-7a7f-49e4-9b90-55218aad89f8"
export ARM_SUBSCRIPTION_ID="9f813689-c99d-4bb7-8f2f-cf48b6b7c046"

function terraform_init() {
  set -u
  terraform init  \
    -backend-config="resource_group_name=eun-ppe-025-sts-tf" \
    -backend-config="storage_account_name=eunppe025ststf" \
    -backend-config="container_name=terraform-state-sts" \
    -backend-config="key=internalakssetup-terraform.tfstate"
}

echo "Running terraform init..."
terraform_init

#echo "Running terraform plan..."
#terraform plan -var-file=terraform-ppe.tfvars

echo "Running terraform apply..."
terraform apply -var-file=terraform-ppe.tfvars

echo "Done!!!"