#!/bin/bash

eval "$(jq -r '@sh "RESOURCE_GROUP=\(.resGrp) VMSS_NAME=\(.vmssName)"')"

ip0=$(az vmss nic list --resource-group $RESOURCE_GROUP  --vmss-name $VMSS_NAME --query "[0].ipConfigurations[0].privateIpAddress")
ip1=$(az vmss nic list --resource-group $RESOURCE_GROUP  --vmss-name $VMSS_NAME --query "[1].ipConfigurations[0].privateIpAddress")
ip2=$(az vmss nic list --resource-group $RESOURCE_GROUP  --vmss-name $VMSS_NAME --query "[2].ipConfigurations[0].privateIpAddress")

ip0=$(echo $ip0 | xargs)
ip1=$(echo $ip1 | xargs)
ip2=$(echo $ip2 | xargs)

echo "{\"myVmssIps\":\"${ip0},${ip1},${ip2}\"}"

