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
GIT_USER="John Hyland"
GIT_EMAIL="jonhyland@hotmail.com"

# configure bash profile
echo "Configuring bash profile.."
ALIAS_LL="alias ll='ls -lF'"
ALIAS_LA="alias la='ls -alF'"
grep -qxF "$ALIAS_LL" $HOME/.profile || echo "$ALIAS_LL" >> $HOME/.profile
grep -qxF "$ALIAS_LA" $HOME/.profile || echo "$ALIAS_LA" >> $HOME/.profile

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
sudo -u $USER git config --global user.name "$GIT_USER"
sudo -u $USER git config --global user.email "$GIT_EMAIL"
sudo -u $USER git config --global credential.helper "cache --timeout=3600"
sudo -u $USER mkdir -p $HOME/git/

# clone (or pull) 'scripts' repo
if [ ! -d "$HOME/git/scripts" ]
then
    echo "Cloning 'scripts' repository.."
    sudo -u $USER git clone "https://github.com/jon-hyland/scripts.git" "$HOME/git/scripts/"
else
    echo "Pulling 'scripts' repository.."
    sudo -u $USER git -C "$HOME/git/scripts" pull
fi

# copy scripts
echo "Copying scripts.."
sudo -u $USER mkdir -p $HOME/scripts/
sudo -u $USER cp $HOME/git/scripts/*.sh $HOME/scripts/

# grant execution on scripts
echo "Granting execution on scripts.."
sudo -u $USER chmod +x $HOME/scripts/*.sh

# success
echo "Operation success"