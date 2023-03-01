#!/bin/bash

echo "Installing Wordpress" > /tmp/test.txt
# db_passwd="HelloWorld_123"

# Installing Apache Web Server
echo "Installing Apache" >> /tmp/test.txt

sudo yum install httpd -y
sudo systemctl start httpd -y 
sudo systemctl enable httpd.service

echo "Finished with Apache" >> /tmp/test.txt
# install php
# wordpress requires php version 7.4

echo "Installing PHP" >> /tmp/test.txt

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm

sudo yum -y install yum-utils
sudo yum-config-manager --enable remi-php74

sudo yum -y update
sudo yum -y install php

sudo yum -y install php  php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json

sudo systemctl restart httpd.service
echo "Finished with Php" >> /tmp/test.txt

# Installing MySQL (MariaDB)

echo "Installing MariaDB" >> /tmp/test.txt
sudo yum install mariadb-server -y
sudo systemctl start mariadb
echo "Done with Mariadb" >> /tmp/test.txt

# echo "Installing expect" >> /tmp/test.txt
# sudo yum install -y expect
# echo "Done with expect" >> /tmp/test.txt

 
echo "Mariadb: $(systemctl status mariadb | grep Active:)" >> /tmp/test.txt


mysql_secure_installation <<EOF

n
y
y
y
y
EOF


# expect -c "
#     set timeout 10
#     spawn mysql_secure_installation

#     expect \"Enter current password for root (enter for none):\"
#     send \"\r\"
#     expect \"Change the root password?\"
#     send \"n\r\"
#     expect \"Remove anonymous users?\"
#     send \"y\r\"
#     expect \"Disallow root login remotely?\"
#     send \"y\r\"
#     expect \"Remove test database and access to it?\"
#     send \"y\r\"
#     expect \"Reload privilege tables now?\"
#     send \"y\r\"
#     expect eof
# "

# set timeout 10

# spawn mysql_secure_installation

# expect {
#     "Enter current password for root (enter for none):" {
#         send "\r"
#         exp_continue
#     }
#     "Set root password?" {
#         send "n\r"
#         exp_continue
#     }
#     "Remove anonymous users?" {
#         send "y\r"
#         exp_continue
#     }
#     "Disallow root login remotely?" {
#         send "y\r"
#         exp_continue
#     }
#     "Remove test database and access to it?" {
#         send "y\r"
#         exp_continue
#     }
#     "Reload privilege tables now?" {
#         send "y\r"
#         exp_continue
#     }
#     eof {
#         puts "MySQL secure installation completed successfully."
#     }
#     timeout {
#         puts "Timeout occurred while waiting for output from mysql_secure_installation."
#         exit 1
#     }
#     default {
#         puts "Unexpected output from mysql_secure_installation: $expect_out(buffer)"
#         exit 1
#     }
# }

echo "Completed mysql secure installation" >> /tmp/test.txt

mysql -e "CREATE DATABASE wordpress;"
mysql -e "CREATE USER wordpressuser@localhost IDENTIFIED BY 'password';"
mysql -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';"
mysql -e "FLUSH PRIVILEGES;"

echo "Configured database" >> /tmp/test.txt



if [[ $(which wget) ]]; then
    cd ~
    wget http://wordpress.org/latest.tar.gz
else
    sudo yum install wget -y
    cd ~
    wget http://wordpress.org/latest.tar.gz
fi

tar xzvf latest.tar.gz

rm -rf latest*

sudo rsync -avP ~/wordpress/ /var/www/html/
mkdir /var/www/html/wp-content/uploads
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo chown -R apache:apache /var/www/html/*

echo "Wordpress downloaded" >> /tmp/test.txt

sed -i 's/database_name_here/wordpress/g' /var/www/html/wp-config.php
sed -i 's/username_here/wordpressuser/g' /var/www/html/wp-config.php
sed -i 's/password_here/password/g' /var/www/html/wp-config.php

echo "All Done" >> /tmp/test.txt