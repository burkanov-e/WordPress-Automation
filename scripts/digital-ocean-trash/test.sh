#!/usr/bin/env bash


# ssh_connection="$(curl -X GET \
#   -H "Content-Type: application/json" \
#   -H "Authorization: Bearer " \
#   "https://api.digitalocean.com/v2/account/keys/" | jq -r '.ssh_keys[].name')"

# using wc -w to count the words in a string and compare it.

IFS=$'\n' #Internation Field Separator

ssh_keys="$(curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer " \
  "https://api.digitalocean.com/v2/account/keys/")"

keys="$(echo $ssh_keys | jq -r '.ssh_keys[].name')"
key_lenght="$(echo $ssh_keys | jq '.ssh_keys | length')"
echo $keys
read -p "please chose the key above, provide index (1-$key_lenght) key_chois

for key in "$(seq 1 $key_lenght)"; do
    echo $key
done
# i=0
# for key in $keys; do
#     i=$(( i + 1 ))
# done

# if [ $i -gt 2 ]
#     for key in $keys; do
#     echo $key
#     done    
    
#     read -p "Please specify the SSH connection to connect to (Please provide name): " name_ssh

# fi

# for key in $keys; do
#     echo $key
#     done

# if [ $(echo "$keys" | wc -w) -gt 2 ]
# then
#     echo good
    
#     # read -p "Please specify the SSH connection to connect to (Please provide numbers): " num_ssh
# fi

