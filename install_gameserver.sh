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

# clone (or pull) 'games' repo
if [ ! -d "$HOME/git/games" ]
then
    echo "Cloning 'games' repository.."
    sudo -u $USER git clone "https://github.com/jon-hyland/games.git" "$HOME/git/games/"
else
    echo "Pulling 'games' repository.."
    sudo -u $USER git -C "$HOME/git/games" pull
fi

# copy scripts
echo "Copying scripts.."
sudo -u $USER mkdir -p $HOME/scripts/
sudo -u $USER cp $HOME/git/games/scripts/*.sh $HOME/scripts/

# grant execution on scripts
echo "Granting execution on scripts.."
sudo -u $USER chmod +x $HOME/scripts/*.sh

# run latest publish script
/bin/bash $HOME/scripts/publish_gameserver.sh
