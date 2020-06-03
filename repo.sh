#!/bin/bash

### Michele Campus - michelecampus5@gmail.com ###
## The script take a repository name as Input and delete it from the existing list under /etc/apt/sources.list.d/ ##

DEL_REPO="$1"
OS="$2"


if [[ "$1" == "-l" && "$OS" == "centos" ]]
then
	ls -l /etc/yum.repos.d/ # print on stdout list of all centos repositories
        exit 1

elif [[ "$1" == "-l" ]] && [[ "$OS" == "debian" ]] || [[ "$OS" == "ubuntu" ]]
then
        ls -l /etc/apt/sources.list.d/ # print on stdout list of all debian/ubuntu repositories
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
