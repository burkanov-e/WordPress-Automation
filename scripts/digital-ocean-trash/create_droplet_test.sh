#!/bin/bash

token=""
read -p "Please provide a name for your droplet: " droplet_name

ssh_id=37405602
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


PS3="Select am image: "
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

clear
droplet_id="$(curl -s -X POST \
  -H "Content-Type:application/json" \
  -H "Authorization: Bearer $token" \
  -d '{"name": "'"$droplet_name"'", "region": "'"$region"'", "size": "'"$size"'", "image": "'"$image"'", "ssh_keys":["'"$ssh_id"'"]}' \
  "https://api.digitalocean.com/v2/droplets" | jq .droplet.id)"

echo $droplet_id
