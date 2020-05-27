#!/bin/bash

# ensure run as root
if [ "$EUID" -ne 0 ]
then
    echo "Must be run as root"
    exit
fi

# break on error
set -e

# vars
HOME="/home/pi"
USER="pi"

# install apache2
if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 0 ]
then
    echo "Installing apache2.."
    apt-get install apache2
fi

# install php
if [ $(dpkg-query -W -f='${Status}' php 2>/dev/null | grep -c "ok installed") -eq 0 ]
then
    echo "Installing php.."
    apt-get install php
fi

# install libapache2-mod-php
if [ $(dpkg-query -W -f='${Status}' libapache2-mod-php 2>/dev/null | grep -c "ok installed") -eq 0 ]
then
    echo "Installing libapache2-mod-php.."
    apt-get install libapache2-mod-php
fi

# install mariadb-server
if [ $(dpkg-query -W -f='${Status}' mariadb-server 2>/dev/null | grep -c "ok installed") -eq 0 ]
then
    echo "Installing mariadb-server.."
    apt-get install mariadb-server
fi

# secure installation
echo "Running 'mysql_secure_installation' command.."
mysql_secure_installation

# install php-mysql
if [ $(dpkg-query -W -f='${Status}' php-mysql 2>/dev/null | grep -c "ok installed") -eq 0 ]
then
    echo "Installing php-mysql.."
    apt-get install php-mysql
fi

# restart apache
echo "Restarting apache.."
sudo service apache2 restart

# create symbolic links
echo "Creating symbolic links.."
rm -f $HOME/site
ln -s /var/www/html $HOME/html
