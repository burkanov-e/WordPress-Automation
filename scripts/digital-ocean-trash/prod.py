import requests
import json
import pprint
import getpass

regions = ["New York", "San Francisco", "Amsterdam"]
region = ""
sizes = ["512MB" "1GB" "2GB" "4GB" "8GB"]
size = ""
images = ["Ubuntu 20.04" "Debian 10" "CentOS 7"]
image = ""

# api_token = getpass.getpass(prompt="Please enter an API token: ")

api_token = ''

api_url_base = 'https://api.digitalocean.com/v2/'

headers = {'Content-Type': 'application/json',
           'Authorization': 'Bearer {0}'.format(api_token)}

pp = pprint.PrettyPrinter(indent=4)


def show_list(lst):
    while True:
        try:
            for index, i in enumerate(lst):
                print(f'{index+1}) {i}')

            ans = int(input('Please choose the option above:(provide numbers) '))
            if ans < 1 or ans > len(lst):
                raise ValueError
            return ans

        except ValueError:
            print("Incorrect input. Please try again!")


def create_droplet(ssh_key):
    regions = ["New York", "San Francisco", "Amsterdam"]
    region = ""
    sizes = ["512MB", "1GB", "2GB", "4GB", "8GB"]
    size = ""
    images = ["Fedora 36x64", "CentOS 7"]
    image = ""

    droplet_name = input("Please provide a name for your droplet: ")
    droplet_url = f'{api_url_base}droplets'

    while True:
        match show_list(regions):
            case 1:
                region = "nyc1"
                break
            case 2:
                region = "sfo1"
                break
            case 3:
                region = "ams2"
                break
            case _:
                "Invalid option, please try again"

    while True:
        match show_list(sizes):
            case 1:
                size = "s-1vcpu-512mb-10gb"
                break
            case 2:
                size = "s-1vcpu-1gb"
                break
            case 3:
                size = "s-1vcpu-2gb"
                break
            case 4:
                size = "s-2vcpu-4gb"
                break
            case 5:
                size = "s-4vcpu-8gb"
                break
            case _:
                "Invalid option, please try again"

    while True:
        match show_list(images):
            case 1:
                image = "fedora-36-x64"
                break
            case 2:
                image = "centos-7-x64"
                break
            case _:
                "Invalid option, please try again"

    with open('~/Dev/prac/bash_scripts/project/userdata_manual.sh', 'r') as f:
        info = {"name": droplet_name, "region": region, "size": size, "image": image,
                "user_data": f.read(), "ssh_keys": ssh_key}

        requests.post(droplet_url, json=info, headers=headers)
    droplet_response = requests.get(droplet_url, headers=headers)
    droplet_resp_text = droplet_response.json()
    droplet_id = droplet_resp_text['droplets']['id']


api_url_keys = f'{api_url_base}account/keys'
keys_response = requests.get(api_url_keys, headers=headers)

key_resp_text = keys_response.json()

ssh_names = []
for key in key_resp_text['ssh_keys']:
    ssh_names.append(str(key['name']))


ssh_id = key_resp_text['ssh_keys'][show_list(ssh_names) - 1]['id']

pp.pprint(ssh_id)


# for key, details in enumerate(resp_text['ssh_keys']):
#     pp.pprint(key)
#     pp.pprint(details)
# pp.pprint('Key: {}: {}'.format(key, resp_text['ssh_keys'][key]['name']))

# if response.status_code == 200:
#     pp.pprint(json.loads(response.content.decode('utf-8')))
# else:
#     pp.pprint('None')
