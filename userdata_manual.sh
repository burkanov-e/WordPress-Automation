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

echo "Mariadb: $(systemctl status mariadb | grep Active:)" >> /tmp/test.txt

# MySQL secure installation

mysql_secure_installation <<EOF

n
y
y
y
y
EOF


echo "Completed mysql secure installation" >> /tmp/test.txt

mysql -e "CREATE DATABASE wordpress;"
mysql -e "CREATE USER wordpressuser@localhost IDENTIFIED BY 'password';"
mysql -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';"
mysql -e "FLUSH PRIVILEGES;"

echo "Configured database" >> /tmp/test.txt

# CURL

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