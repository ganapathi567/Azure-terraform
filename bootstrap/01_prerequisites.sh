#!/bin/bash

set -uo pipefail

# install the CLI to manipulate Azure via Azure Resource Manager
brew install azure-cli

# install the tool used for provisioning the environment in Azure
brew install terraform

# helm for manipulating K8S deployments
brew install helm
