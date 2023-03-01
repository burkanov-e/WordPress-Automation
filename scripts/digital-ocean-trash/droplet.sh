#!/bin/bash 

token=""
read -p "Please provide a name for your droplet: " droplet_name
# function_name() {
#     url=""
#     data=""
    
# } 

##if something happens check with the connection check jq commnad

get_ssh_id() {
  ssh_id="$(curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  "https://api.digitalocean.com/v2/account/keys/" | jq '.ssh_keys[0].id')"

  echo $ssh_id
}

get_droplet_id() {
  droplet_id="$(curl -X POST \
  -H "Content-Type:application/json" \
  -H "Authorization: Bearer $token" \
  -d '{"name":'["$droplet_name"]',"region":"nyc3","size":"s-1vcpu-1gb","image":"centos-7-x64", "ssh_keys":'["$ssh_id"]'}' \
  "https://api.digitalocean.com/v2/droplets" | jq .droplet.id)"

  echo $droplet_id
}




sleep 30

## setting ip_address variable to establish SSH connection ##
ip_address="$(curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  "https://api.digitalocean.com/v2/droplets/$droplet_id" | jq .droplet.networks.v4[0].ip_address)" 


read -p "do you want to configure to your ssh?(Y/N) " ssh_config_ans

## ~/.ssh/id_rsa
while [[ "$ssh_config_ans" != "Y" ]] && [[ "$ssh_config_ans" != "N" ]]; do
    echo "The input that you provided is not correct. Please try again."
    read -p "Please provide an input:(Y/N) " ssh_config_ans
done

if [[ "$ssh_config_ans" == "Y" ]]; then
    cat <<EOF >> ~/.ssh/config
    
Host $droplet_name
    Hostname $ip_address
    User root
    IdentityFile ~/.ssh/id_rsa
EOF
fi




