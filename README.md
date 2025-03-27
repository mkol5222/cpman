# make cpman

Quick way from zero (or almost zero) to Check Point Security Management in Azure.

## Prerequisites

- Azure subscription
- Github account (optional) - Github Codespaces as your devops environment

## Step 1: Obtain Azure Service Principal in Azure Cloud Shell

Open [Azure Cloud Shell](https://shell.azure.com) in Bash  and run the following commands:

```bash
# optional
az logout; az login --identity

# review script
curl -sL https://run.klaud.online/make-sp.sh

# once audited, obtain your encrypted credentials as env variables SP
source <(curl -sL https://run.klaud.online/make-sp.sh)
```

Result: take note of `export SP=encrypted_credentials` command for later use.

## Step 2: Back in Github Codespaces devops environment

```bash
# introduce encrypted credentials to Codespaces from Azure Cloud Shell output
export SP=encrypted_credentials

# get SP into devops environment - results in sp.json
make get-sp
cat sp.json | jq .

# start automated deployment
make cpman

# wait until deployment is complete and CPMAN is ready to accept SmartConsole and API connections

```

Result: take note about Security Management IP and credentials for SmartConsole.

### CLEANUP

Once machine is not needed, you can remove creted cloud resources with.
Also remember removing unnecessary admin Service Principal.

```bash
make cleanup

# which is same as
make cpman-down
make sp-down
```

Result: all cloud resources and credentials are removed.