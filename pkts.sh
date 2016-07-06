#!/bin/bash

#
# Michele Campus (camus@ntop.org)
#
# bash script for measurment the
# average packets number received
# by the specified net interface
#

 
INTERVAL="1"  # interval in seconds
N_PPS=0
SUM_TIME=0
X=0
D=0

trap calc_avg SIGINT SIGTERM # trap for signals termination

check_dev_linux()
{
    dev_list=$( tail -n +3 /proc/net/dev | cut -d':' -f1 )
    for dev in $dev_list; do
	if [ "$1" = "$dev" ]; then
	    D=1
	fi
    done
}
	
fn_usage()
{
    printf "\nusage for $0: 
             -i: specify a network-interface
             -s: set time (in seconds) for capturing pkts [optional]
             e.g. $0 -i wlan0\n"
    exit
}

calc_avg()
{

    AVG=$(echo "scale=3; $N_PPS/$SUM_TIME" | bc )
    printf "\n----------------STATS-------------------\n"
    printf "\nInterface --> $i\n"
    printf "\nAverage packets captured = $AVG pkts/s\n"
    printf "\n----------------------------------------\n"
    exit
}

if [ "$#" -eq 0 ]; then
    echo "Invalid number of arguments" >&2
    fn_usage
    exit 1
fi

# getops
while getopts "i:s:" opt; do
    case "${opt}" in
        i)
            i=${OPTARG}
	    check_dev_linux $i
	    if [ "$D" == 0 ]; then
		echo "Option: "$OPTARG" must be a real name of network device" >&2
		fn_usage
		exit 1
	    fi;;
        s)
            s=${OPTARG}
	    if [ "$s" -eq "$s" ] 2>/dev/null # check s (must be integer)
	    then
	    TIMER=s
	    X=1
	    else
		echo "Invalid option: "$OPTARG" must be an integer value" >&2
		fn_usage
		exit 1
	    fi;;
	\?)
	    fn_usage
            exit 1;;
    esac
done
shift $((OPTIND-1))


while true
do
    R1=$( cat /sys/class/net/$i/statistics/rx_packets )
    sleep $INTERVAL
    R2=$( cat /sys/class/net/$i/statistics/rx_packets )

    RXPPS=$( expr $R2 - $R1 )
    
    if [ "$RXPPS" -gt 0 ]; then
	((N_PPS += RXPPS))
    fi

    ((TIMER -= 1))
    ((SUM_TIME += 1))

    printf "Pkts received: $RXPPS pkts/s\n"

    if [ "$X" == 1 ]; then
	if [ $TIMER == 0 ]; then
	    kill -SIGTERM "$$"
	fi
    fi  
done
