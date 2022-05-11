#!/bin/bash

#
# bash script to detect the OS
#
OS=`grep '^NAME' /etc/os-release | awk -F= {'print $2'}`
SUB=`echo $OS | cut -d' ' -f 1`
OS="${SUB:1}"

ID=`grep '^VERSION_ID' /etc/os-release | awk -F= {'print $2'}`
REL=`grep '^VERSION_CODENAME' /etc/os-release | awk -F= {'print $2'}`

echo "$OS $ID $REL"
