# User Data
## Installing Wordpress script

### The wordpress enviroment requires the **LAMP (Linux, Apache, MySQL, PHP/Python/Perl).** 
### **Note:** They are not preinstalled in the system. 

<br>

### **Step One: Installing Apache**

<br>

```console
sudo yum install httpd -y
sudo systemctl start httpd -y 
sudo systemctl enable httpd.service
```

- The systemctl command **manages both system and service configurations, enabling administrators to manage the OS and control the status of services.**

<br>

### **Step Two: Installing PHP**

<br>

### The wordpress requires the PHP version 7.4 or higher

<br>

```console
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm

sudo yum -y install yum-utils
sudo yum-config-manager --enable remi-php74

sudo yum -y update
sudo yum -y install php

sudo yum -y install php  php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json

sudo systemctl restart httpd.service
```
 
<br>

### **Step Three: Installing MySQL**

<br>

- We need to install a MySQL in our case it's MariaDB. This allows us to create databases.

```console
sudo yum install -y expect
sudo yum install mariadb-server -y
sudo systemctl start mariadb 
```

**Expect** command or **expect scripting language** is a language that talks with your interactive programs or scripts that require user interaction.

**Learn more about expect: https://likegeeks.com/expect-command/**

<br>

### **Creating a database inside of the MariaDB**

```console
mysql -e "CREATE DATABASE wordpress;"
mysql -e "CREATE USER wordpressuser@localhost IDENTIFIED BY 'password';"
mysql -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';"
mysql -e "FLUSH PRIVILEGES;"
```

**GRANT ALL ON** gives all permissions to the user *wordpressuser*

<br>

### **Step Four: Installing Wordpress**

<br>

```console
wget http://wordpress.org/latest.tar.gz
sudo rsync -avP ~/wordpress/ /var/www/html/
mkdir /var/www/html/wp-content/uploads
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo chown -R apache:apache /var/www/html/*
```

**Note: All files inside of the /var/www/html/ should be own by apache**

After this we need to change the default database_name, username and password inside of the var/www/html/wp-config.php file.

```console
sed -i 's/database_name_here/wordpress/g' /var/www/html/wp-config.php
sed -i 's/username_here/wordpressuser/g' /var/www/html/wp-config.php
sed -i 's/password_here/password/g' /var/www/html/wp-config.php
```

**Learn more about sed command: https://www.geeksforgeeks.org/sed-command-in-linux-unix-with-examples/**

**Database_name:** wordpress

**Username:** wordpressuser

**Password:** password

<br><br>


