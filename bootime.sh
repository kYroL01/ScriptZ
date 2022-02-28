#!/bin/bash

#
# bash script to show system reboot and shutdown date and time
#
echo "--------------------------------------------"
echo "--- time of last system boot ---"
who -b
echo
echo "--- last reboot ---"
last reboot
echo
echo "--- last shutdown ---"
last shutdown
echo
echo "--- how long the system has been running ---"
uptime
cat /proc/uptime
awk '{ print "up " $1 /60 " minutes"}' /proc/uptime 
w
echo "--------------------------------------------"
