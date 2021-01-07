#!/bin/bash

#
# bash script to detect the OS
#
OS=`grep '^NAME' /etc/os-release | awk -F= {'print $2'}`
SUB=`echo $OS | cut -d' ' -f 1`
OS="${SUB:1}"
echo "$OS"
