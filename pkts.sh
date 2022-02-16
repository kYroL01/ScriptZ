#!/bin/bash
#
# author: Michele Campus
#
# bash script to calculate the average packets of a network interface
# - received
# - dropped
# - errors
#

#set -x

FILE=pkts-net.log
INTERVAL="1"  # interval in seconds
N_PPS=0
N_DROP=0
N_ERR=0
SUM_TIME=0
DUMP=0
X=0
D=0
V=0
#NOW=$(date +"%d_%m_%Y")
NOW=$(date)

# trap for signals termination - trigger the execution of the functions when one of the signal is catched
trap handler SIGINT SIGTERM

function fn_usage()
{
    printf "\nusage for $0:
             -i [net interface]: specify a network-interface
             -s [sec]          : set time (in seconds) for capturing pkts [optional]
             -l                : print the list of availlable network interfaces
             -v                : verbose - print every received/dropped/errors pkt per second
             -d                : dump information with date in a file called pkts-net.log
             (e.g. $0 -i wlan0)\n"
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

function calc_avg_rcv()
{
    AVG_RX=$(echo "scale=3; $N_PPS/$SUM_TIME" | bc )
    if [ "$DUMP" -eq 1 ]; then
        echo " " >> "$FILE"
        echo "[$NOW]" >> "$FILE"
        echo "-------------------RX STATS----------------------" >> "$FILE"
        echo "Interface --> $i" >> "$FILE"
        echo "Average packets captured = $AVG_RX pkts/s" >> "$FILE"
        echo "#################################################" >> "$FILE"
        printf "RX STATS info stored in pkts-net.log\n"
    else
        printf "\n--------------------RX STATS---------------------\n"
        printf "\nInterface --> $i\n"
        printf "\nAverage packets captured = $AVG_RX pkts/s\n"
        printf "\n#################################################\n"
    fi
}

function calc_avg_drop()
{
    AVG_DROP=$(echo "scale=3; $N_DROP/$SUM_TIME" | bc )
    if [ "$DUMP" -eq 1 ]; then
        echo "-----------------RX DROP STATS-------------------" >> "$FILE"
        echo "Interface --> $i" >> "$FILE"
        echo "Average packets dropped = $AVG_DROP pkts/s" >> "$FILE"
        echo "#################################################" >> "$FILE"
        printf "RX DROP STATS info stored in pkts-net.log\n"
    else
        printf "\n----------------RX DROP STATS--------------------\n"
        printf "\nInterface --> $i\n"
        printf "\nAverage packets dropped = $AVG_DROP pkts/s\n"
        printf "\n#################################################\n"
    fi
}

function calc_avg_err()
{
    AVG_DROP=$(echo "scale=3; $N_ERR/$SUM_TIME" | bc )
    if [ "$DUMP" -eq 1 ]; then
        echo "-----------------RX ERR STATS--------------------" >> "$FILE"
        echo "Interface --> $i" >> "$FILE"
        echo "Average packets error = $AVG_ERR pkts/s" >> "$FILE"
        echo "#################################################" >> "$FILE"
        printf "RX ERR STATS info stored in pkts-net.log\n"
    else
        printf "\n----------------RX ERR STATS---------------------\n"
        printf "\nInterface --> $i\n"
        printf "\nAverage packets error = $AVG_ERR pkts/s\n"
        printf "\n#################################################\n"
    fi
}

function handler() {
    calc_avg_rcv
    calc_avg_drop
    calc_avg_err
    exit
}

###############################################################

if [ "$#" -eq 0 ]; then
    echo "Invalid number of arguments" >&2
    fn_usage
    exit 1
fi

# getops
while getopts "i:s:ldvh" opt; do
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
        d)
            DUMP=1;;
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
    E1=$( cat /sys/class/net/$i/statistics/rx_errors  )
    sleep $INTERVAL
    R2=$( cat /sys/class/net/$i/statistics/rx_packets )
    D2=$( cat /sys/class/net/$i/statistics/rx_dropped )
    E2=$( cat /sys/class/net/$i/statistics/rx_errors  )

    RXPPS=$( expr "$R2" - "$R1" )
    DROPPPS=$( expr "$D2" - "$D1" )
    ERRPPS=$( expr "$E2" - "$E1" )

    if [ "$RXPPS" -gt 0 ]; then
	    ((N_PPS += RXPPS))
    fi
    if [ "$DROPPPS" -gt 0 ]; then
	    ((N_DROP += DROPPPS))
    fi
    if [ "$ERRPPS" -gt 0 ]; then
	    ((N_ERR += ERRPPS))
    fi

    ((TIMER -= 1))
    ((SUM_TIME += 1))

    # verbose
    if [ "$V" -eq 1 ]; then
        printf "Pkts received correctly: $RXPPS   pkts/s\n"
        printf "Pkts received dropped:   $DROPPPS pkts/s\n"
        printf "Pkts received error:     $ERRPPS  pkts/s\n"
    fi

    if [ "$X" == 1 ]; then
	    if [ $TIMER == 0 ]; then
	        kill -SIGTERM "$$"
	    fi
    fi
done
