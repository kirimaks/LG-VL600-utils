#!/bin/bash 

set -e

devices=("1-1.6.1" "1-1.6.2" "1-1.6.3" "1-1.6.4")

for device in ${devices[*]}; do
	sudo sh -c "echo 1 > /sys/bus/usb/devices/$device/bConfigurationValue"
done

