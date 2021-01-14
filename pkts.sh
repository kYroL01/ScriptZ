#!/bin/bash
#
# bash script for measurment the
# average packets number received and dropped
# by the specified network interface
#

#set -x

FILE=pkts_net.txt
INTERVAL="1"  # interval in seconds
N_PPS=0
N_DROP=0
SUM_TIME=0
X=0
D=0
V=0

# trap for signals termination - trigger the execution of the functions when one of the signal is catched
trap handler SIGINT SIGTERM

function fn_usage()
{
    printf "\nusage for $0:
             -i [net interface]: specify a network-interface
             -s [sec]          : set time (in seconds) for capturing pkts [optional]
             -l                : print the list of availlable network interfaces
             -v                : verbose - print every pkt received/dropped per sec
             e.g. $0 -i wlan0\n"
    exit
}

function check_dev_linux()
{
    dev_list=$( tail -n +3 /proc/net/dev | cut -d':' -f1 )
    for dev in $dev_list; do
	    if [ "$1" = "$dev" ]; then
	        D=1
	    fi
    done
}

function calc_avg()
{
    AVG_RX=$(echo "scale=3; $N_PPS/$SUM_TIME" | bc )
    printf "\n----------------RX STATS-------------------\n"
    echo "----------------RX STATS-------------------" >> "$FILE"
    printf "\nInterface --> $i\n"
    echo "Interface --> $i" >> "$FILE"
    printf "\nAverage packets captured = $AVG_RX pkts/s\n"
    echo "Average packets captured = $AVG_RX pkts/s" >> "$FILE"
    printf "\n-------------------------------------------"
    echo "-------------------------------------------" >> "$FILE"
}

function calc_drop()
{
    AVG_DROP=$(echo "scale=3; $N_DROP/$SUM_TIME" | bc )
    printf "\n----------------DROP STATS-------------------\n"
    echo "----------------DROP STATS-------------------" >> "$FILE"
    printf "\nInterface --> $i\n"
    echo "Interface --> $i"
    printf "\nAverage packets dropped = $AVG_DROP pkts/s\n"
    echo "Average packets dropped = $AVG_DROP pkts/s"
    printf "\n---------------------------------------------\n"
    echo "---------------------------------------------"
    exit
}

function handler() {
    calc_avg
    calc_drop
}

###############################################################

if [ "$#" -eq 0 ]; then
    echo "Invalid number of arguments" >&2
    fn_usage
    exit 1
fi

# getops
while getopts "i:s:lvh" opt; do
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
	        if [ "$s" -eq "$s" ] 2>/dev/null; then
	            TIMER=s
	            X=1
	        else
		        echo "Invalid option: "$OPTARG" must be an integer value" >&2
		        fn_usage
		        exit 1
	        fi;;
        l)
            ip a
            exit 1;;
        v)
            V=1;;
        h)
            fn_usage                                                                                                                                  
            exit 1;;
	    \?)
	        fn_usage
            exit 1;;
    esac
done
shift $((OPTIND-1))

###############################################################

while true
do
    R1=$( cat /sys/class/net/$i/statistics/rx_packets )
    D1=$( cat /sys/class/net/$i/statistics/rx_dropped )
    sleep $INTERVAL
    R2=$( cat /sys/class/net/$i/statistics/rx_packets )
    D2=$( cat /sys/class/net/$i/statistics/rx_dropped )

    RXPPS=$( expr $R2 - $R1 )
    DROPPPS=$( expr $D2 - $D1 )
    
    if [ "$RXPPS" -gt 0 ]; then
	    ((N_PPS += RXPPS))
    fi
    if [ "$DROPPPS" -gt 0 ]; then
	    ((N_DROP += DROPPPS))
    fi

    ((TIMER -= 1))
    ((SUM_TIME += 1))

    # verbose
    if [ "$V" -eq 1 ]; then
        printf "Pkts received: $RXPPS   pkts/s\n"
        printf "Pkts dropped:  $DROPPPS pkts/s\n"
    fi

    if [ "$X" == 1 ]; then
	    if [ $TIMER == 0 ]; then
	        kill -SIGTERM "$$"
	    fi
    fi  
done
