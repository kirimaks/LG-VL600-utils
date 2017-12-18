#!/bin/bash


# set -x

if [ "$(whoami)" != "root" ]; then
	echo "Need to run as root"
	exit 0
fi


LOCAL_NET="192.168.0.0/24"

nmap -sS $LOCAL_NET -p3128

for vmName in $(virsh list --name)
do
	tput setaf 3
	echo "Checking: [$vmName]"
	tput sgr0

	mac=$(virsh domiflist $vmName|grep br0|awk '{print $5}')
	echo -e "\tmac: $mac"

	ip=$(arp -n |grep $mac|awk '{print $1}')
	echo -e "\tip: $ip"

	# vpnIp=$(ssh -t root@$ip "ip addr show dev tun0|grep inet" 2> /dev/null)
	# vpnIp=$(echo $vpnIp|awk '{print $2}')
	# echo -e "\tvpn: $vpnIp"

	out=$(ssh -t root@$ip "/usr/bin/python3 /root/LG-VL600-utils/vl600-get-signal-strength.py" 2> /dev/null)
	echo -e "\tsignal: $out"

done
