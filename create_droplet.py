from tqdm import tqdm
from time import sleep
import requests
import getpass
import json
import os
import inquirer
import pprint
# api to list
api_token = getpass.getpass(
    "Please provide an API token (Token will be hidden): ")
api_url_base = 'https://api.digitalocean.com/v2/'

headers = {'Content-Type': 'application/json',
           'Authorization': 'Bearer {0}'.format(api_token)}


def get_ssh():
    get_droplet_url = f'{api_url_base}account/keys'
    response = requests.get(get_droplet_url, headers=headers)

    if len(response.json()['ssh_keys']) == 1:
        ssh_id = response.json()['ssh_keys'][0]['id']
        return ssh_id
    elif len(response.json()['ssh_keys']) > 1:

        ssh_lst = [key['name'] for key in response.json()['ssh_keys']]

        ssh_question = [
            inquirer.List('name',
                          message="Please choose the ssh_key to connect:",
                          choices=ssh_lst,
                          ),
        ]

        ssh_response = inquirer.prompt(ssh_question)['name']

        for i in response.json()['ssh_keys']:
            if i['name'] == ssh_response:
                return i['id']


def lst_specs():
    # Name
    name = inquirer.text(message="Enter the name for droplet name")

    # Region
    reg_url = f'{api_url_base}regions'
    reg_api = requests.get(reg_url, headers=headers)
    reg_response = reg_api.json()
    lst_reg = [key['name'] for key in reg_response['regions']]

    reg_question = [

        inquirer.List('region',
                      message="Which region would you like to choose?",
                      choices=lst_reg,
                      ),
    ]

    reg_ans = inquirer.prompt(reg_question)

    for i in reg_response['regions']:
        if i['name'] == reg_ans['region']:
            slug = i['slug']
            size_lst = i['sizes']

    # Size
    size_question = [
        # name = inquirer.text(message="Enter the name for droplet name")
        inquirer.List('size',
                      message="Which size would you like to choose?",
                      choices=size_lst,
                      ),
    ]

    size_ans = inquirer.prompt(size_question)['size']

    # Image

    image_url = f'{api_url_base}images'
    image_api = requests.get(image_url, headers=headers)
    image_response = image_api.json()
    image_lst = [key['description'] for key in image_response['images']]

    image_question = [
        # name = inquirer.text(message="Enter the name for droplet name")
        inquirer.List('image',
                      message="Which image would you like to choose?",
                      choices=image_lst,
                      ),
    ]

    image_ans = inquirer.prompt(image_question)['image']

    for i in image_response['images']:
        if i['description'] == image_ans:
            image_slug = i['slug']

    # User_Data

    with open('userdata_manual.sh', 'r') as f:
        user_data_contents = f.read()

    info = {
        "name": name,
        "region": slug,
        "size": size_ans,
        "image": image_slug,
        "user_data": user_data_contents,
        "ssh_keys": get_ssh()
    }

    return info


def create_droplet():
    # droplet_url = f'{api_url_base}droplets'

    droplet_url = f'{api_url_base}droplets'
    info = lst_specs()
    droplet = requests.post(droplet_url, json=info, headers=headers)
    print(droplet.json()['droplet']['id'])
    return droplet.json()['droplet']['id']


def get_ip_address(id):  # 341814676
    for i in tqdm(range(30), desc="Loading..."):
        sleep(1)
        pass
    # os.system("sleep 30")
    get_droplet_url = f'{api_url_base}droplets/{id}'
    response = requests.get(get_droplet_url, headers=headers)
    return response.json()['droplet']['networks']['v4'][0]['ip_address']


ip_addr = get_ip_address(create_droplet())
print("Digital Ocean Droplet Created, Secure Shell..")
while True:
    os.system(f"ssh root@{ip_addr} 2>/dev/null")


print(os.path.abspath('userdata_manual.sh'))


# ssh config
