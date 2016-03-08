#!/bin/bash

#Pulizia pacchetti inutilizzati (autoremove) e cache pacchetti (autoclean e clean)
echo -n "<< Pulizia pacchetti inutilizzati >>"

#Pulizia (autoremove) pacchetti inutilizzati
sudo apt-get autoremove
echo "RIMOZIONE PACCHETTI INUTILIZZATI	...[OK]"
#Pulizia cache pacchetti
sudo apt-get autoclean
sudo apt-get clean
echo "PULIZIA CACHE DEI PACCHETTI		...[OK]"


#File temporanei e cestino
echo -n "<< Cancellazione file temporanei e svuotamento cestino >>"

#Rimozione file temporanei (/tmp)
sudo rm -fr /tmp/*
echo "RIMOZIONE FILE TEMPOREANEI		...[OK]"
#Rimozione file del cestino (.local/share/Trash)
sudo rm -rf ~/.local/share/Trash/*
echo "RIMOZIONE FILE NEL CESTINO		...[OK]"
#Rimozione file thumbnail (.thumbnails)
sudo rm -rf ~/.thumbnails/*
echo "RIMOZIONE THUMBNAIL			...[OK]"


#Rimozione cache browser
echo -n "<< Cancellazione cache dei browser >>"

sudo rm -rf ~/.mozilla/firefox/*.default/Cache/* #Firefox/Iceweasel
echo "RIMOZIONE CACHE FIREFOX/ICEWEASEL	...[OK]"
sudo rm -rf ~/.cache/google-chrome/Default/Cache/* #Google Chrome
echo "RIMOZIONE CACHE GOOGLE CHROME		...[OK]"


#Rimozione conversazioni Skype
echo -n "<< Rimozione conversazioni Skype >>"
sudo rm -rf ~/.Skype/*/chatmsg*.dbb #Skype
echo "RIMOZIONE CONVERSAZIONI SKYPE		...[OK]"


echo "Pulizia completata. Juve merda!!"

exit
