#!/bin/bash

# set -x

if [ "$(whoami)" != "root" ]; then
	echo "Need to run as root"
	exit 0
fi

domain=$1
bus=$2
dev=$3

if [ -z "$domain" ] || [ -z "$bus" ] || [ -z "$dev" ]; then
	echo "Run as: ./attach-usb.sh Domain busNum devNum"
	exit 0
fi


virsh attach-device $domain /dev/stdin << END
<hostdev mode='subsystem' type='usb'>
  <source>
    <address bus='${bus}' device='${dev}' />
  </source>
</hostdev>	
END
