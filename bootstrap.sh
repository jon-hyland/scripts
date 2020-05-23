#!/bin/bash

# ensure run as root
if [ "$EUID" -ne 0 ]
then
    echo "Must be run as root"
    exit
fi

# break on error
set -e

# update and upgrade packages
echo "Updating and upgrading system.."
apt-get update
apt-get upgrade

# install git
if [ $(dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed") -eq 0 ]
then
    echo "Installing Git.."
    apt-get install git
fi

# configure git
echo "Configuring Git.."
sudo -u pi git config --global user.name "John Hyland"
sudo -u pi git config --global user.email "jonhyland@hotmail.com"
sudo -u pi git config --global credential.helper "cache --timeout=3600"
sudo -u pi mkdir -p /home/pi/git/

# clone (or pull) 'scripts' repo
if [ ! -d "/home/pi/git/scripts" ]
then
    echo "Cloning 'scripts' repository.."
    sudo -u pi git clone "https://github.com/jon-hyland/scripts.git" "/home/pi/git/scripts/"
else
    echo "Pulling 'scripts' repository.."
    sudo -u pi git -C "/home/pi/git/scripts" pull
fi

# success
echo "Operation success"