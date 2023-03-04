
# **Documentations For create_droplet.sh**
### **This program is automates the creation of DigitalOcean droplet and installation of wordpress inside of the droplet**

<br>

### **Prerequisites:**
* A DigitalOcean account
* A DigitalOcean API token
* A JQ command 

***How to obtain a DigitalOcean API token:***
1. Log in to your DigitalOcean account.
  
2. Navigate to the API section under the Account tab in the left-hand navigation menu.
  
3. Click on the "Generate New Token" button under the "Personal access tokens" section.
   
4. In the "New personal access token" popup, give the token a descriptive name, select the "Read & Write" scopes, and click "Generate Token".
   
#### **Important:** Please make sure to save your API token, as you won't be able to access it again once you close the window.
<br>

**How to install JQ command**

<br>

**For Mac:** Open terminal and run this command **brew install jq**

**For Windows:** Please follow the steps in this link **https://www.shellhacks.com/git-bash-install-jq/**

**For Debian based Linux:** Open terminal and run this command **sudo apt install jq -y**

**For RedHat based Linux** Open terminal and run this command **sudo yum install jq -y**

<br>

## **Part One: Creating a Droplet**

<br>

### **Step One: Get input from user about the specification of a droplet( create_droplet() funciton)**

<br>

The droplet specification for every user is different. We want to make it flexible and let users choose their own droplet configuration. In this part program uses tools such as **JQ (json file manipulation), Select, Case, PS3** 

- **jq** is a tool for processing JSON inputs, applying the given filter to
its JSON text inputs and producing the filter's results as JSON on
standard output

- **select - https://linuxhint.com/bash_select_command/** 

- **case - https://www.tutorialspoint.com/unix/case-esac-statement.htm**

- **PS3** The bash environment variable $PS3 is the prompt used by select. Set it to a new value and you'll get a new prompt

<br>

```console
regions=("New York" "San Francisco" "Amsterdam")

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
```

Here case command is running inside of the select loop. It allows user to interact with the command prompt and choose specification they want. Here is the specification that API can take in order to create a droplet **https://slugs.do-api.dev/**

Learn more about DigitalOcean API calls: **https://docs.digitalocean.com/reference/api/api-reference/#operation/droplets_list**

<br>

### **Step Two: sending API to create a droplet**

<br>

```console
curl -s -X POST \
    -H "Content-Type:application/json" \
    -H "Authorization: Bearer $api_token" \
    -d '{"name": "'"$droplet_name"'", "region": "'"$region"'", "size": "'"$size"'", "image": "'"$image"'", "user_data": "'"$(cat ~/userdata_manual.sh)"'", "ssh_keys":[ '"$ssh_key"' ] }' \
    "https://api.digitalocean.com/v2/droplets" | jq .droplet.id
```
Once we get the information about the droplet specification we need to provide a ***user_data** which will install additional software and configured to users specification.* In our case it's the second file called **userdata_manual.sh** 

**User_data:** A string containing 'user data' which may be used to configure the Droplet on first boot, often a 'cloud-config' file or Bash script. It must be plain text and may not exceed 64 KiB in size.

<br>

### **Step Three: Getting the ip_address configuring and connecting to the server** 

<br>

Once the droplet created, we need to obtain the ip_address of the droplet to connect to our remote server. 

- First we need to obtain the ip_address by sending an API call

```console
droplet=$(create_droplet)

curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $api_token" \
  "https://api.digitalocean.com/v2/droplets/$droplet" | jq -r '.droplet.networks.v4[0].ip_address
```
<br>

- Then user have to answer if they want to configure the ip_address in the **/.ssh/config file**. If the answer is "Y" then we run following commands to configure the **/.ssh/config file**

```console
cat <<EOF >> ~/.ssh/config

Host $droplet_name 
    Hostname $ip_address
    User root
    IdentityFile ~/.ssh/id_rsa
EOF
```
Here we appending our configuration using **heredoc**

Learn more about **heredoc** https://phoenixnap.com/kb/bash-heredoc

#### **Note:** heredoc is very case-space sensitive!

<br>






