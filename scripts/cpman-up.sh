#!/bin/bash

set -euo pipefail

# does sp.json exist?
if [ ! -f sp.json ]; then
  echo "sp.json not found. Follow instructions in setup.azcli to create sp.json in Azure Shell or locally."
  exit 1
fi

AZ_SUBSCRIPTIONID=$(jq -r .subscriptionId sp.json)
AZ_TENANTID=$(jq -r .tenant sp.json)
AZ_APPID=$(jq -r .appId sp.json)
AZ_PASSWORD=$(jq -r .password sp.json)

# am I able to login with it?
az account show --subscription "${AZ_SUBSCRIPTIONID}" &>/dev/null || {
  echo "Logging in with SP ${AZ_APPID} in tenant ${AZ_TENANTID}"
  az login -o table --service-principal \
    --tenant "${AZ_TENANTID}" \
    --username "${AZ_APPID}" \
    --password "${AZ_PASSWORD}"
}

# init infra
export TF_VAR_client_id="${AZ_APPID}"
export TF_VAR_client_secret="${AZ_PASSWORD}"
export TF_VAR_subscription_id="${AZ_SUBSCRIPTIONID}"
export TF_VAR_tenant_id="${AZ_TENANTID}"

export TZ=Europe/Paris

echo -n "Deploying cpman (TF init): "; date
(cd cpman; terraform init)


echo -n "Deploying cpman: "; date
(cd cpman; terraform apply -auto-approve)
echo -n "Deployment cpman with TF done: "; date
echo

