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

# install ufw (firewall)
if [ $(dpkg-query -W -f='${Status}' ufw 2>/dev/null | grep -c "ok installed") -eq 0 ]
then
    echo "Installing ufw.."
    apt-get install ufw
fi

# configure firewall
echo "Configuring firewall.."
sudo ufw enable
echo "Alowing SSH port 22.."
sudo ufw allow 22
sudo ufw limit ssh/tcp  # limit 6 attempts per ip per 30 seconds
echo "Alowing HTTP port 80.."
sudo ufw allow 80
echo "Alowing HTTP port 443.."
sudo ufw allow 443

# install fail2ban (intrusion detection / prevention)
if [ $(dpkg-query -W -f='${Status}' fail2ban 2>/dev/null | grep -c "ok installed") -eq 0 ]
then
    echo "Installing fail2ban.."
    apt-get install fail2ban
fi

# configure fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
rm -f $HOME/jail.local
sudo -u $USER ln -sf /etc/fail2ban/jail.local $HOME/jail.local

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

# ensure write access (for ftp, etc)
chown pi /var/www/html

# restart apache
echo "Restarting apache.."
sudo service apache2 restart

# create symbolic links
echo "Creating symbolic links.."
rm -f $HOME/site
sudo -u $USER ln -sf /var/www/html $HOME/site
