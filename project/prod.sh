#!/bin/bash

read -sp "Please provide an API token: " api_token
IFS=$'\n' #Internation Field Separator

# The -s option tells curl to be silent, 
# while the 2>/dev/null redirection hides the progress information.
ssh_keys="$(curl -sS -X GET \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $api_token" \
"https://api.digitalocean.com/v2/account/keys/" 2>/dev/null)"

key_length="$(echo "$ssh_keys" | jq '.ssh_keys | length')"
echo -e "\nThere are $key_length SSH keys available "

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
    PS3="Please select the SSH key: "
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

ssh_key=$(getSSH)
echo $ssh_key

read -p "Please provide a name for your droplet: " droplet_name

create_droplet() {
    regions=("New York" "San Francisco" "Amsterdam")
    sizes=("512MB" "1GB" "2GB" "4GB" "8GB")
    images=("Ubuntu 20.04" "Debian 10" "CentOS 7")
    region=
    size=
    image=

    PS3="Select a region: "
    select opt in "${regions[@]}"; do
    case $opt in
        "New York")
            region="nyc1"
            break
        ;;
        "San Francisco")
            region="sfo1"
            break
        ;;
        "Amsterdam")
            region="ams2"
            break
        ;;
        #Anything else will be invalid option
        *)
        echo "Invalid option, please try again."
        ;;
    esac
    done

    PS3="Select a size: "
    select opt in "${sizes[@]}"; do
    case $opt in
        "512MB")
        size="s-1vcpu-512mb-10gb"
        break
        ;;
        "1GB")
        size="s-1vcpu-1gb"
        break
        ;;
        "2GB")
        size="s-1vcpu-2gb"
        break
        ;;
        "4GB")
        size="s-2vcpu-4gb"
        break
        ;;
        "8GB")
        size="s-4vcpu-8gb"
        break
        ;;

        #Anything else will be invalid option
        *)
        echo "Invalid option, please try again."
        ;;
    esac
    done

    PS3="Select an image: "
    select opt in "${images[@]}"; do
    case $opt in
        "Ubuntu 20.04")
        image="ubuntu-20-04-x64"
        break
        ;;
        "Debian 10")
        image="debian-10-x64"
        break
        ;;
        "CentOS 7")
        image="centos-7-x64"
        break
        ;;

        #Anything other will be invalid option
        *)
        echo "Invalid option, please try again."
        ;;
    esac
    done

    droplet_id="$(curl -s -X POST \
    -H "Content-Type:application/json" \
    -H "Authorization: Bearer $api_token" \
    -d '{"name": "'"$droplet_name"'", "region": "'"$region"'", "size": "'"$size"'", "image": "'"$image"'", "user_data": "'"$(cat ~/Dev/prac/bash_scripts/project/userdata_manual.sh)"'", "ssh_keys":[ '"$ssh_key"' ] }' \
    "https://api.digitalocean.com/v2/droplets" | jq .droplet.id)"

    echo $droplet_id
}

droplet=$(create_droplet)
echo -e "\n$droplet"

sleep 30

## setting ip_address variable to establish SSH connection ##
ip_address="$(curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $api_token" \
  "https://api.digitalocean.com/v2/droplets/$droplet" | jq -r '.droplet.networks.v4[0].ip_address')"

echo -e "Configuring your SSH allows to connect to the VM just by typing <ssh $droplet_name>"
read -p "Do you want to configure to your ssh?(Y/N) " ssh_config_ans

## ~/.ssh/id_rsa
while [[ "$ssh_config_ans" != "Y    " ]] && [[ "$ssh_config_ans" != "N" ]]; do
    echo "The input that you provided is not correct. Please try again."
    read -p "Please provide an input:(Y/N) " ssh_config_ans
done

if [[ "$ssh_config_ans" == "Y" ]]; then
    cat ~/.ssh/config | grep -w $droplet_name
    
    if [[ $(echo $?) == 0 ]]; then
        read -p "Please choose different config name: " new_droplet_name
        cat <<EOF >> ~/.ssh/config

Host $new_droplet_name 
    Hostname $ip_address
    User root
    IdentityFile ~/.ssh/id_rsa
EOF

    sleep 5
    while true; do ssh $new_droplet_name; done


    else
        cat <<EOF >> ~/.ssh/config

Host $droplet_name 
    Hostname $ip_address
    User root
    IdentityFile ~/.ssh/id_rsa
EOF

    sleep 5
    while true; do ssh $droplet_name; done
    fi

    else 
    sleep 5
        while true; do ssh root@$ip_address; done
fi