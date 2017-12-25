#!/bin/bash

set -x

source /etc/profile.d/proxy.sh

me=$(basename "$0")

function openPort() {
	currentRule=$(/sbin/iptables -nL INPUT|grep $PROXY_PORT)
	if [ -z "$currentRule" ]; then
		logger -t $me "Openning port: [$PROXY_PORT]"
		/sbin/iptables -I INPUT -p tcp --dport $PROXY_PORT -j ACCEPT
	fi
}

if [ ! -e "$IP_CHANGING_LOCK" ]; then

	/usr/bin/curl -q --max-time 15 $IP_CHECK_URL > /dev/null 2>&1

	if [ $? -eq 0 ];then
		logger -t $me "Ok"
		openPort
	else
		logger -t $me "Not ok. Restart modem"

		# $PROXY_SCRIPTS/reset-modem.sh
		sleep 15
		$PROXY_SCRIPTS/change-ip.sh
	fi
else
	logger -t $me "IP still changing, exit."
	exit 0
fi

# check vpn
ping -c 1 -W 3 $VPN_ROOT_IP
if [ $? -eq 1 ];then
	logger -t $me "Restart VPN"
	/bin/systemctl restart openvpn@client
else
	logger -t $me "VPN OK"
fi
