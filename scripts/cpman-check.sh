#!/bin/bash

set -euo pipefail
# echo each command
# set -x

# does sp.json exist?
if [ ! -f sp.json ]; then
  echo "sp.json not found. Follow instructions in setup.azcli to create sp.json in Azure Shell or locally."
  exit 1
fi

ENVID=$(jq -r .envId sp.json)
echo "ENVID: $ENVID"
RGNAME="cpman-tf-$ENVID"

# cpman ip
#az vm list-ip-addresses -g "$RGNAME" -n cpman -o json | jq -r '.[0].virtualMachine.network.publicIpAddresses[0].ipAddress'
CPMAN_IP=$(az vm list-ip-addresses -g "$RGNAME" -n cpman -o json | jq -r '.[0].virtualMachine.network.publicIpAddresses[0].ipAddress')
echo "cpman_ip: $CPMAN_IP"

function check_mgmt_api {
  
    # login to cpman API
    U=admin
    P='Welcome@Home#1984'

    # POST https://<mgmt-server>:<port>/web_api/login
    mgmt_server="https://$CPMAN_IP"

    # POST {{server}}/login
    # Content-Type: application/json

    # {
    #   "user" : "aa",
    #   "password" : "aaaa"
    # }

    # login

    RESP=$(curl -m 3 -ks -X POST $mgmt_server/web_api/login -H 'Content-Type: application/json' -d "{\"user\":\"$U\",\"password\":\"$P\"}")
    # check if resp is valid JSON
    if echo "$RESP" | jq empty >/dev/null 2>&1; then
        echo "Management is READY"
    else
        echo "Management API not ready"
        return
    fi

    sid=$(echo "$RESP" | jq -r .sid)
    # echo "sid: $sid"
    if [ "$sid" == "null" ]; then
    echo "Failed to login to Management API. Try again later."
    return 
    fi

    if [ "$sid" == "" ]; then
    echo "Failed to login to Management API. Try again later."
    return 
    fi

    echo
    echo "DONE: Management server is READY"
}

echo -n "Started waiting for cpman: "; date
echo -n "Checking Management API readiness"
while true; do
    # returns "DONE" if ready
    
    if [ "$(check_mgmt_api | grep -c "DONE" )" -gt 0 ]; then
        break
    fi

    echo -n "."
    sleep 5
done
echo
echo "Management API is ready. Connect to ${CPMAN_IP}"
echo -n "Done waiting for cpman: "; date
echo