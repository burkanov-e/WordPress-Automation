#!/bin/bash

# The -s option tells curl to be silent, 
# while the 2>/dev/null redirection hides the progress information.
    
read -sp "Please provide an API token: " api_token
IFS=$'\n'


ssh_keys="$(curl -sS -X GET \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $api_token" \
"https://api.digitalocean.com/v2/account/keys/" 2>/dev/null)"

key_length="$(echo "$ssh_keys" | jq '.ssh_keys | length')"
echo -e "\nThere are $key_length SSH keys available, please select one to establish the connection: "

getSSH() {

if [ "$key_length" -gt 1 ]; then
    # Create an array of key names
    names_array=()
    for key in $(seq 0 "$(($key_length-1))"); do
        key_name="$(echo "$ssh_keys" | jq -r '.ssh_keys['"$key"'].name')"
        names_array+=("$key_name")
    done

    # Prompt the user to select a key
    # echo "There are $key_length SSH keys available, please select one to establish the connection:"
    select opt in "${names_array[@]}" Quit; do
        case $opt in
            "Quit")
                break
            ;;
            "") 
                # No value found
                echo "Invalid option"
            ;;
            *)
                echo "You have selected $opt"
                ssh_id="$(echo "$ssh_keys" | jq -r '.ssh_keys[] | select(.name=="'$opt'").id')"
                break
            ;;
        esac
    done

else
    # If there's only one key, use it
    ssh_id="$(echo "$ssh_keys" | jq -r '.ssh_keys[0].id')"
fi

echo "$ssh_id"
}



result="$(getSSH)"
echo "${result}"