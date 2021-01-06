#!/bin/bash

# Script bash to convert 
# 1. numbers from one base to another
# 2. extension of multilpe files in a directory

# usage --  ./converter 1 [base] [number]
# usage --  ./converter 2 [old_ext] [new_ext]

if [ "$1" -eq 1 ] then
	echo "obase=$1; $2" | bc
fi

if [ "$1" -eq 2] then
	for f in *.pcapng; do mv -- "$f" "${f%.pcapng}.pcap"; done
fi
