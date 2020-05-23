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

# clone (or pull) 'games' repo
if [ ! -d "$HOME/git/games" ]
then
    echo "Cloning 'games' repository.."
    sudo -u pi git clone "https://github.com/jon-hyland/games.git" "$HOME/git/games/"
else
    echo "Pulling 'games' repository.."
    sudo -u pi git -C "$HOME/git/games" pull
fi

# grant execution on scripts
echo "Granting execution on scripts.."
sudo -u pi chmod +x $HOME/git/games/scripts/*.sh

# create symbolic links to scripts
echo "Creating symbolic links to scripts.."
sudo -u pi ln -sf $HOME/git/games/scripts/publish_gameserver.sh $HOME/publish_gameserver.sh
sudo -u pi ln -sf $HOME/git/games/scripts/restart_gameserver.sh $HOME/restart_gameserver.sh

# run latest publish script
/bin/bash $HOME/git/games/scripts/publish_gameserver.sh
