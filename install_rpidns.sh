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

# clone (or pull) 'rpi' repo
if [ ! -d "$HOME/git/rpi" ]
then
    echo "Cloning 'rpi' repository.."
    sudo -u pi git clone "https://github.com/jon-hyland/rpi.git" "$HOME/git/rpi/"
else
    echo "Pulling 'rpi' repository.."
    sudo -u pi git -C "$HOME/git/rpi" pull
fi

# grant execution on scripts
echo "Granting execution on scripts.."
sudo -u pi chmod +x $HOME/git/rpi/scripts/*.sh

# run latest installation scripts
/bin/bash $HOME/git/rpi/scripts/install_dnsmasq.sh
/bin/bash $HOME/git/rpi/scripts/publish_rpidns.sh
