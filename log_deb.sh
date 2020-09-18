#!/bin/bash

### for Debian ###

### LOGS
FILE_R=log.txt
cat /var/log/syslog | grep "$1" >> "$FILE_R"

### System Logs
FILE_S=system_info.txt
date >> "$FILE_S"
echo "-- iostat --" >> "$FILE_S"
iostat -p >> "$FILE_S"
echo "-- vmstat -- " >> "$FILE_S"
vmstat >> "$FILE_S"
echo "-- netstat -- " >> "$FILE_S"
netstat -anus >> "$FILE_S"
