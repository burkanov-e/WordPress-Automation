#!/bin/bash

echo "Installing LAMP in your machine"

user_passwd="Qwerty12345"
db_passwd="HelloWorld_123"

# Installing Apache Web Server
sudo yum install httpd -y && sudo systemctl start httpd -y && sudo systemctl enable httpd.service

# Installing MySQL (MariaDB)
sudo yum install mariadb-server -y && sudo systemctl start mariadb 

# yum install -y expect

expect -c "
    set timeout 10
    spawn mysql_secure_installation

    expect \"Enter current password for root (enter for none):\"
    send \"\r\"
    expect \"Change the root password?\"
    send \"n\r\"
    expect \"Remove anonymous users?\"
    send \"y\r\"
    expect \"Disallow root login remotely?\"
    send \"y\r\"
    expect \"Remove test database and access to it?\"
    send \"y\r\"
    expect \"Reload privilege tables now?\"
    send \"y\r\"
    expect eof
"



# # read -p "Did you give password for your database?(Y/N) " ans
# # echo "We need a passord to configure an environment to install a wordpress"

# # while [[ "$ans" != "Y" ]] && [[ "$ans" != "N" ]]; do
# #     read -p "The input that you provided is not correct. Please try again.(Y/N) " ans
# # done

# # if [[ "$ans" == "Y" ]]; then
#     # echo "Note: password will be hidden when typing"
#     # read -sp "Please provide a password for your mysql database: " db_passwd
#     # read -sp "Please provide a user password inside of the database: " user_passwd

#     mysql -u root -p${db_passwd} -e "CREATE DATABASE wordpress;"
#     mysql -u root -p${db_passwd} -e "CREATE USER wordpressuser@localhost IDENTIFIED BY '${user_passwd}';"
#     mysql -u root -p${db_passwd} -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY '${user_passwd}';"
#     mysql -u root -p${db_passwd} -e "FLUSH PRIVILEGES;"

# # else 
# #     echo "Note: password will be hidden when typing"
# #     read -sp "Please provide a user password inside of the database: " user_passwd

# #     mysql -e "CREATE DATABASE wordpress;"
# #     mysql -e "CREATE USER wordpressuser@localhost IDENTIFIED BY '${user_passwd}';"
# #     mysql -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY '${user_passwd}';"
# #     mysql -e "FLUSH PRIVILEGES;"
# # fi

# #installing php
# sudo yum install php php-mysql -y && sudo systemctl restart httpd.service && sudo yum install php-gd -y
# sudo service httpd restart

# if [[ $(which wget) ]]; then
#     cd ~
#     wget http://wordpress.org/latest.tar.gz
# else
#     sudo yum install wget -y
#     cd ~
#     wget http://wordpress.org/latest.tar.gz
# fi

# tar xzvf latest.tar.gz

sudo rsync -avP ~/wordpress/ /var/www/html/
mkdir /var/www/html/wp-content/uploads
sudo chown -R apache:apache /var/www/html/*

cp /var/www/html/wp-config-sample.php wp-config.php

cat <<EOF >> ~/wp-config.php
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wordpressuser');

/** MySQL database password */
define('DB_PASSWORD', 'password');
EOF



