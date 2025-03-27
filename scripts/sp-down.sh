#!/bin/bash

set -euo pipefail

if [ ! -f sp.json ]; then
  echo "sp.json not found. Follow instructions in setup.azcli to create sp.json in Azure Shell or locally."
  exit 1
fi

echo 
# wait for one character
K=$(read -n 1 -s -r -p "Are you sure you want to delete the SP and sp.json? (y/N)")
echo
if [ "${K}" != "y" ]; then
  echo "Aborted."
  exit 1
fi

AZ_APPID=$(jq -r .appId sp.json)
echo "Deleting SP ${AZ_APPID}"
az ad sp delete --id "${AZ_APPID}"
echo "SP deleted."
echo

echp "Deleting sp.json"
rm -f sp.json

unset SP
echo "Logging out."
az logout

echo "SP deleted and sp.json removed."
