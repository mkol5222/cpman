### "make cpman'

Service Principal - diagram
https://www.tldraw.com/f/8vPdjLYtGeXBXnmTa6SFx?d=v0.-432.1500.847.TjD3Ua07YHmDW-aBkJCVV


### make SP for Codespace in Azure Shell

https://shell.azure.com/

```shell

function makeSp() {

    if az account show > /dev/null 2>&1; then
        echo "User is logged in"
    else
        echo "No user logged in"
        return 1
    fi

    userType=$(az account show --query "{role: user.type}" --output tsv)
    echo "User type: $userType" 

    # for user get SP ID
    if [ "$userType" == "user" ]; then
        userId=$(az ad signed-in-user show --query id -o tsv)
    else
        echo "Supprted only for user"
        return 1
    fi
    
    subscriptionId=$(az account show --query id -o tsv)
    echo "Subscription ID: $subscriptionId"

    if [ $(az role assignment list --role Owner --scope "/subscriptions/${subscriptionId}" --query "[].{role:roleDefinitionName, scope:scope}" --output tsv --assignee $userId | wc -l) -eq 0 ]; then
        echo "User is not Owner of subscription"
        return 1
    else
        echo "User is Owner of subscription"
    fi

}
makeSp