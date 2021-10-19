#!/bin/bash
ip0=$(az vmss nic list --resource-group (.resGrp) --vmss-name (.vmssName) --query "[0].ipConfigurations[0].privateIpAddress")
ip1=$(az vmss nic list --resource-group (.resGrp) --vmss-name (.vmssName) --query "[1].ipConfigurations[0].privateIpAddress")
ip2=$(az vmss nic list --resource-group (.resGrp) --vmss-name (.vmssName) --query "[2].ipConfigurations[0].privateIpAddress")
ip0=${ip0:1:14}
ip1=${ip1:1:14}
ip2=${ip2:1:14}
echo "{\"myVmssIps\":\"${ip0},${ip1},${ip2}\"}"

