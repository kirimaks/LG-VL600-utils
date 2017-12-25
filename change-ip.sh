#!/bin/bash

set -x

source /etc/profile.d/proxy.sh

me=$(basename "$0")

function closePort() {
	/sbin/iptables -D INPUT -p tcp --dport $PROXY_PORT -j ACCEPT	
}

if [ ! -e "$IP_CHANGING_LOCK" ]; then

	echo "Run" > $IP_CHANGING_LOCK

	closePort

	sleep $EXIST_CONN_WAIT # existing connections
	logger -t $me "Waiting $EXIST_CONN_WAIT for existing connection"

	/sbin/dhclient -x ${MODEM_INTERFACE}
	sleep 2
	/sbin/dhclient -1 -v ${MODEM_INTERFACE}

	rm -v $IP_CHANGING_LOCK

	sleep 2
	$PROXY_SCRIPTS/healtch-checker.sh

else
	logger -t $me "Already running, exit"
fi
