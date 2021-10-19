#!/bin/bash

export ARM_CLIENT_ID="ebcd994b-5670-41c1-86b3-b9eba79b83ab"
export ARM_CLIENT_SECRET='8D#R4WjlqlH!eOCD'
export ARM_TENANT_ID="f55b1f7d-7a7f-49e4-9b90-55218aad89f8"
export ARM_SUBSCRIPTION_ID="9b5ef196-6cf0-4c6c-bea7-68dc747ee888"

function terraform_init() {
  set -u
  terraform init  \
    -backend-config="resource_group_name=eun-dev-025-sts-tf" \
    -backend-config="storage_account_name=eundev025ststf" \
    -backend-config="container_name=terraform-state-sts" \
    -backend-config="key=terraform.tfstate.acr"
}

echo "Running terraform init..."
terraform_init

echo "Running terraform plan..."
terraform plan -var-file=terraform-dev.tfvars

#echo "Running terraform apply..."
#terraform apply -var-file=terraform-dev.tfvars

echo "Done!!!"