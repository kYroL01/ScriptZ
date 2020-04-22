#!/bin/bash

#
# Michele Campus (michelecampus5@gmail.com)
#
# bash script for a fast clean
#

# Autoremove and autoclean
printf "<<<--- Deleting packets --->>>\n" 

printf "DELETING UNUSED PACKETS         	...[OK]\n" 
sudo apt-get autoclean
sudo apt-get clean
printf "DELETING PACKETS CACHE  		...[OK]\n" 


# Temporary file and trash
printf "<< Deleting temporary file and empty trash >>\n" 

sudo rm -fr /tmp/*
printf "DELETING TEMPORARY FILE 		...[OK]\n" 
sudo rm -rf ~/.local/share/Trash/*
printf "EMPTYNG TRASH		                ...[OK]\n" 
sudo rm -rf ~/.thumbnails/*
printf "DELETING THUMBNAIL			...[OK]\n" 



# Local Cache
printf "<< Deleting local cache >>\n" 
sudo rm -rf ~/.cache/*
printf "DELETING LOCAL CACHE FILES		...[OK]\n" 

# Docker cleaning
printf "<< Deleting docker containers >>\n" 
sudo docker container prune
printf "DELETING DOCKER CONTAINER		...[OK]\n" 
printf "<< Deleting docker images >>\n" 
sudo docker image prune -a
printf "DELETING DOCKER IMAGES			...[OK]\n" 


printf "<<<--- Clean completed. Juve merda!! --->>>\n"

exit
