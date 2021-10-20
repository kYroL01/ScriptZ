#!/bin/bash

#
# bash script using tshark to extract network layer informations
# from the network packets on any interface
#

### Tunneling check
IS_VLAN=0
IS_VXLAN=0
IS_GRE=0
IS_WEBSOCK_HTTP=0
### SIP+RTP check
IS_SIP=0
IS_SDP=0
IS_RTP=0
IFACE=any

function fn_usage()
{
    printf "usage for $0:
             -c [num pkts]:      How many pkts you want to capture and analyze
             -i [net interface]: Specify a network-interface (any if not specified)
             e.g. $0 -c 1000 -i wlan0
		  $0 -c 2500\n"
    exit
}

if [ "$#" -eq 0 ]; then
    echo "Invalid number of arguments" >&2
    fn_usage
    exit 1
fi

function os_detect()
{
    OS=`grep '^NAME' /etc/os-release | awk -F= {'print $2'}`
    SUB=`echo $OS | cut -d' ' -f 1`
    OS="${SUB:1}"
}

os_detect
echo "OS is $OS"

### check if tshark is installed
ts=`which -a tshark`
if [ -z "$ts" ]; then
    if [ "$OS" == "Centos" ]; then
        `yum update`
        `yum -y install wireshark`
    elif [[ "$OS" == "Debian" || "$OS" == "Ubuntu" ]]; then
        echo "HERE"
        `apt-get update`
        `apt-get install wireshark`
    fi
fi

if [ "$#" -eq 2 ]; then
	IFACE="$2" 
fi

### call TSHARK on N pkts
tshark -c "$1" -i any -T fields -e frame.protocols -e frame.len &> protocols.txt

function parser()
{
    if [[ $line == *"vxlan"* ]]; then
        IS_VXLAN=1
    fi
    if [[ $line == *"vlan"* ]]; then
        IS_VLAN=1
    fi
    if [[ $line == *"gre"* ]]; then
        IS_GRE=1
    fi
    if [[ $line == *"websocket"* ]]; then
        IS_WEBSOCK_HTTP=1
    fi
    if [[ $line == *"sip"* ]]; then
        IS_SIP=1
        if [[ $line == *"sdp"* ]]; then
            IS_SDP=1
        fi
    fi
    if [[ $line == *"rtp"* ]]; then
        IS_RTP=1
    fi    
}

while IFS= read -r line
do
    parser $line
done < protocols.txt

### PRINT RESULT
echo "---------------------"
echo "----- TUNNELING -----"
if [[ "$IS_VXLAN" -eq 1 ]]; then
    echo "VXLAN detected"
fi
if [[ "$IS_VLAN" -eq 1 ]]; then
    echo "VLAN detected"
fi
if [[ "$IS_GRE" -eq 1 ]]; then
    echo "GRE/ERSPAN detected"
fi
if [[ "$IS_WEBSOCK_HTTP" -eq 1 ]]; then
    echo "WEBSOCKET HTTP detected"
fi
if [[ "$IS_VXLAN" -eq 1 ]]; then
    echo "VXLAN detected"
fi
echo "---------------------"
echo "-------- SIP --------"
if [[ "$IS_SIP" -eq 1 ]]; then
    echo "SIP detected"
fi
if [[ "$IS_SDP" -eq 1 ]]; then
    echo "SIP/SDP detected"
fi
echo "-------- RTP --------"
if [[ "$IS_RTP" -eq 1 ]]; then
    echo "RTP detected"
fi
echo "---------------------"

## remove protocols.txt created
rm -rf protocols.txt 
