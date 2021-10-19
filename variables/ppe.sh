#!/bin/bash

# resolve the scripts directory to be able to issue the source command againt this script from anywhere
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# the order of the variables and the function matters
export TESCO_REGION=eun
export TESCO_ENVIRONMENT=ppe
export AZURE_SUBSCRIPTION_NAME=025-PROD-APP-1

# source the common variables
. ${scriptDir}/common.sh

export AZ_SP_PIPELINE=${TESCO_REGION}-${TESCO_ENVIRONMENT}-${TESCO_TEAM_NUMBER}-${TESCO_TEAM_NAME}-rootsp
export SPLUNK_INDEX_NAME=finance_preprod

#DNS settings
export DNS_POSTFIX=""
