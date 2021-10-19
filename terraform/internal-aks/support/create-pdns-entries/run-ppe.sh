#!/bin/bash

## create pdns entries for the internal LB(standard layer 4) placed in front of the internal-aks.

## login to PROD subscription using ppe rootsp credentials.
az login --service-principal --username 'c075239a-ee64-4789-9e17-586658785a54' --password 'JVWlImX.jBP8C.Q#' --tenant 'f55b1f7d-7a7f-49e4-9b90-55218aad89f8'
az account set --subscription 9f813689-c99d-4bb7-8f2f-cf48b6b7c046

## fetch the EXTERNAL-IP of the Nginx ingress ctrl's k8s service (of type LoadBalancer) using the following cmd:
LoadBalancer_IP=$(kubectl -n ingress-nginx get svc nginx-ingress-ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo Load Balancer ip is: $LoadBalancer_IP

az network private-dns record-set a add-record -g eun-prod-025-sts-pdns -z ppe.sts.eun.azure.tesco.org -n internalaks -a $LoadBalancer_IP
az network private-dns record-set a add-record -g eun-prod-025-sts-pdns -z ppe.sts.eun.azure.tesco.org -n jenkins -a $LoadBalancer_IP