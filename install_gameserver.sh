#!/bin/bash

# ensure run as root
if [ "$EUID" -ne 0 ]
then
    echo "Must be run as root"
    exit
fi

# break on error
set -e

# clone (or pull) 'games' repo
if [ ! -d "/home/pi/git/games" ]
then
    echo "Cloning 'games' repository.."
    sudo -u pi git clone "https://github.com/jon-hyland/games.git" "/home/pi/git/games/"
else
    echo "Pulling 'games' repository.."
    sudo -u pi git -C "/home/pi/git/games" pull
fi

# run latest publish script
/bin/bash /home/pi/git/games/scripts/publish_gameserver.sh
