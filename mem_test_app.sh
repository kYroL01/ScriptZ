#!/bin/bash
#
# author: Michele Campus
#
# bash script to test memory consumption of an application
# it prints result in test_mem.log
#

read -p "New test ? [yes/no] " new
if [ "$new" == "yes" ]; then
	rm -rf test_mem.log
fi
echo "" >> test_mem.log
read -p "Number of test: " num_test
echo "$num_test" >> test_mem.log
read -p "Description: " descr
echo "$descr" >> test_mem.log
if [ "$new" == "no" ]; then
	read -p "Program name: " progr
fi

# free mem command
free -h >> test_mem.log

if [ "$num_test" -gt 0 ]; then
	cat /proc/$(pgrep "$progr")/status | grep -i Threads >> test_mem.log
fi

if [ "$?" -gt 0 ]; then
	rm test_mem.log
fi

