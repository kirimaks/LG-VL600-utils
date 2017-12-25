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

	printf "\t3128port: "
	port=$(nmap -oG - -sS $ip -p3128|grep open)
	if [ -n "$port" ]; then
		tput setaf 2
		echo "[OPEN]"
	else
		tput setaf 1
		echo "[CLOSED]"
	fi
	tput sgr0

	echo ""
done
