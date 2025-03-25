

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