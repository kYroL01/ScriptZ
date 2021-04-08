#!/bin/bash

#
# The script create a self-signed certificate using openSSL with no psswd (for quick tests)
# example: openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
#

if [ "$1" == "-h" ]; then
	echo "param 1 = RSA dimension"
	echo "param 2 = KEY name"
	echo "param 3 = CERTIFICATE name"
	echo "param 4 = VALID date (in days)"
	echo "### example of a valid command : openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes ###"
	exit
fi

RSA_DIM="$1"
KEY_NAME="$2"
CERT_NAME="$3"
DAYS="$4"

openssl req -x509 -newkey rsa:"$RSA_DIM" -keyout "$KEY_NAME".pem -out "$CERT_NAME".pem -days "$DAYS" -nodes
