#!/bin/bash

### Michele Campus - michelecampus5@gmail.com ###
## The script take a repository name as Input and delete it from the existing list under /etc/apt/sources.list.d/ ##

DEL_REPO="$1"
OS="$2"

if [ "$1" == "-l" ]
then
	ls -l /etc/apt/sources.list.d/
	exit 1
fi

if [[ "$OS" == "debian" || "$OS" == "ubuntu" ]]
then # Debian - Ubuntu
	if [ -f /etc/apt/sources.list.d/"${DEL_REPO}" ]
	then
		sudo rm /etc/apt/sources.list.d/"${DEL_REPO}"
	else
		echo "!!! Repository ${DEL_REPO} in ${OS} NOT FOUND !!!"
		exit 1
	fi
else # Centos
	if [ -f /etc/yum.repos.d/"${DEL_REPO}" ]
	then
		sudo rm /etc/yum.repos.d/"${DEL_REPO}"
        else
                echo "!!! Repository ${DEL_REPO} in ${OS} NOT FOUND !!!"
                exit 1
        fi
fi

echo "--- Repository ${DEL_REPO} deleted successfully in ${OS} ---"
