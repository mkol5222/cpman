

```shell
cat sp.json | jq .

make cpman 2>&1 | tee /tmp/deploy.log

export TZ=Europe/Paris
date


###

# enc


# pass on cli
echo -n '{"key":"value"}' | openssl enc -aes-256-cbc -salt -pbkdf2 -base64 -A -pass pass:YOUR_PASSWORD
# interactive password
date  | openssl enc -aes-256-cbc -salt -pbkdf2 -base64 -A 

# apply on sp.json
cat sp.json | openssl enc -aes-256-cbc -salt -pbkdf2 -base64 -A 
# Codespace env var AZ_SP has the JSON
env | grep AZ_SP

echo "$AZ_SP" | openssl enc -aes-256-cbc -d -salt -pbkdf2 -base64 -A 
echo "$AZ_SP" | openssl enc -aes-256-cbc -d -salt -pbkdf2 -base64 -A  | jq -r 'to_entries | map("X_" + .key + "=" + .value) | join(" ")'
export $( echo "$AZ_SP" | openssl enc -aes-256-cbc -d -salt -pbkdf2 -base64 -A  | jq -r 'to_entries | map("AZSP_" + .key + "=" + .value) | join(" ")' ); env | grep ^AZSP_

# dec

echo -n "U2FsdGVkX19WS2EOlSQ0P8hVXKjP48uC/FcaFM+Yrz4=" | openssl enc -aes-256-cbc -d -salt -pbkdf2 -base64 -A -pass pass:YOUR_PASSWORD


export $( echo "$TOPSECRET" | openssl enc -aes-256-cbc -d -salt -pbkdf2 -base64 -A  | jq -r 'to_entries | map("TOPSEC_" + .key + "=" + .value) | join(" ")' ); env | grep ^AZSP_


echo export $( echo "$TOPSECRET" | openssl enc -aes-256-cbc -d -salt -pbkdf2 -base64 -A  | jq -r 'to_entries | map("TOPSEC_" + .key + "=" + .value) | join(" ")' )

# gen env id
envId=$(for i in {1..8}; do printf "%x" $((RANDOM % 16)); done)
echo "Environment ID: $envId"

# check is logged into Azure and if Owner on subscription scope
az account show --query "{subscriptionId:id, tenantId:tenantId, user:userId, role: user.type}" --output table

# get my azure id and ask for role assignments
az ad signed-in-user show --query "{objectId:objectId, userPrincipalName:userPrincipalName}" --output table
# /me request is only valid with delegated authentication flow.
# alternatives way to get logged in SP is when this error?
az account get-access-token --query "{objectId: user.identity}" --output json 

# works for SP
az account show --query 'user.name' -o tsv
az ad sp show --id $(az account show --query 'user.name' -o tsv)

az role assignment list --assignee <objectId> --all --query "[].{role:roleDefinitionName, scope:scope}" --output table

az ad signed-in-user show

# check user owners of current subscription
az role assignment list --role "Owner" --scope /subscriptions/$(az account show --query id -o tsv) --query "[?principalType=='User']" -o table
# check SP owners of current subscription
az role assignment list --role "Owner" --scope /subscriptions/$(az account show --query id -o tsv) --query "[?principalType=='ServicePrincipal']" -o table

# name or logged-in SP
az account show --query 'user.name' -o tsv
az ad sp show --id $(az account show --query 'user.name' -o tsv) -o table

# name of logged-in user
az account show --query 'user.name' -o tsv
az ad sp show --id $(az account show --query 'user.name' -o tsv) -o table
# principal representing the signed-in user
az ad signed-in-user show --query "{objectId:objectId, userPrincipalName:userPrincipalName}" --output table
# get id of signed-in user
az ad signed-in-user show --query id -o tsv

# not logged in Azure
if [ $(az account show --query 'state' -o tsv | wc -l) -eq 0 ]; then
    echo "User is not logged in Azure"
    return 1
fi
# better
if az account show > /dev/null 2>&1; then
    echo "User is logged in"
else
    echo "No user logged in"
fi

# query default account of az account show by isDefault == true
userType=$(az account show --query "{role: user.type}" --output tsv)
echo "User type: $userType" 

# for user get SP ID
if [ "$userType" == "user" ]; then
    userId=$(az ad signed-in-user show --query id -o tsv)
else
    userId=$(az account show --query 'user.name' -o tsv)
fi
echo "userId: $userId"

# role assignments
#az role assignment list --assignee $userId --all --query "[].{role:roleDefinitionName, scope:scope}" --output table

subscriptionId=$(az account show --query id -o tsv)
echo "Subscription ID: $subscriptionId"

az role assignment list --role Owner --scope "/subscriptions/${subscriptionId}" --query "[].{role:roleDefinitionName, scope:scope}" --output table --assignee $userId

# current user is not owner
if [ $(az role assignment list --role Owner --scope "/subscriptions/${subscriptionId}" --query "[].{role:roleDefinitionName, scope:scope}" --output tsv --assignee $userId | wc -l) -eq 0 ]; then
    echo "User is not Owner of subscription"
    exit 1
else
    echo "User is Owner of subscription"
fi

subscriptionId=$(az account show --query id -o tsv)
echo "Subscription ID: $subscriptionId"

envId=$(for i in {1..8}; do printf "%x" $((RANDOM % 16)); done)
echo "Environment ID: $envId"
spname=$(echo "sp-cpman-$envId")
echo "Service Principal Name: $spname"
NEWSP=$(az ad sp create-for-rbac --name $spname --role Owner --scopes /subscriptions/$subscriptionId -o json)
echo "$NEWSP" | jq -r --arg E "$envId" --arg S "$subscriptionId" '. | .envId = $E | .subscriptionId = $S | .name = "sp-cpman-" + $E'

az ad sp list --show-mine --output table

# $sp = az ad sp create-for-rbac --name $spname --role Owner --scopes /subscriptions/$subscriptionId -o json | ConvertFrom-Json
# $sp | Add-Member -MemberType NoteProperty -Name envId -Value $envId
# $sp | Add-Member -MemberType NoteProperty -Name subscriptionId -Value $subscriptionId
# $sp | Add-Member -MemberType NoteProperty -Name name -Value $spname
# $sp | ConvertTo-Json | Out-File -FilePath sp.json
# gc sp.json


### azure shell re-login
az logout
az login --identity