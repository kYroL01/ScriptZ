#!/bin/bash

### for Debian ###

### RTPAGENT LOGS
FILE_R=rtpagent_log.txt
cat /var/log/syslog | grep rtpagent >> "$FILE_R"

### ZIP file or rtpagent config
ZIP_FILE=rtpagent_config.zip
CONFIG_PATH=/usr/local/rtpagent/etc
zip -r "ZIP_FILE" "CONFIG_PATH"

### System Logs
FILE_S=system_info.txt
date >> "$FILE_S"
echo "-- iostat --" >> "$FILE_S"
iostat -p >> "$FILE_S"
echo "-- vmstat -- " >> "$FILE_S"
vmstat >> "$FILE_S"
echo "-- netstat -- " >> "$FILE_S"
netstat -anus >> "$FILE_S"
