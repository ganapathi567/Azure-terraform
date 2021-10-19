
# login using ppe root-sp

#e65b0ad9-ba15-4d43-b1e1-4b98c83f593d --> AZ-025-PROD-APP-1-Contributors grp

az role assignment create \
    --role "Storage Account Contributor" \
    --assignee "e65b0ad9-ba15-4d43-b1e1-4b98c83f593d" \
    --scope "/subscriptions/9f813689-c99d-4bb7-8f2f-cf48b6b7c046/resourceGroups/eun-ppe-025-sts-app/providers/Microsoft.Storage/storageAccounts/eunppe025stsapp"

az role assignment create \
    --role "Storage Blob Data Owner" \
    --assignee "e65b0ad9-ba15-4d43-b1e1-4b98c83f593d" \
    --scope "/subscriptions/9f813689-c99d-4bb7-8f2f-cf48b6b7c046/resourceGroups/eun-ppe-025-sts-app/providers/Microsoft.Storage/storageAccounts/eunppe025stsapp"
