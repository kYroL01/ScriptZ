#!/bin/bash

#
# Michele Campus (campus@ntop.org)
#
# bash script for a fast clean
#

# Autoremove and autoclean
printf "<< Deleting packets >>\n" 

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


# Browser cache
printf "<< Deleting browsers cache >>\n" 

sudo rm -rf ~/.mozilla/firefox/*.default/Cache/* #Firefox/Iceweasel
printf "DELETING FIREFOX/ICEWEASEL CACHE	...[OK]\n" 
sudo rm -rf ~/.cache/google-chrome/Default/Cache/* #Google Chrome
printf "DELETING GOOGLE CHROME CACHE		...[OK]\n" 


# Skype
printf "<< Deleting skype conversations >>\n" 
sudo rm -rf ~/.Skype/*/chatmsg*.dbb #Skype
printf "DELETING SKYPE CONVERSATIONS		...[OK]\n" 


printf "--- Clean completed. Juve merda!! ---\n"

exit
