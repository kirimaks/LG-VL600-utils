#!/bin/bash


detachDevice() {
	dev=$(echo $1|sed -E "s/^0+//")
	bus=$(echo $2|sed -E "s/^0+//")
	./detach-usb.sh $vmName $bus $dev
}


for vmName in $(virsh list --name)
do
	echo "$vmName:"

	addrs="$(virsh dumpxml $vmName|xpath -q -e '/domain/devices/hostdev/source/address')"

	IFS='/>'
	for addr in $addrs
	do
		addr="$(echo $addr|tr -d '\n')"
		if [ -n "$addr" ];then
			addr=$(echo $addr|sed "s/\s$//")
			addr="$addr/>"

			bus=$(echo "$addr"|xpath -q -e '/address/@bus'|grep -oE '[0-9]+')
			dev=$(echo "$addr"|xpath -q -e '/address/@device'|grep -oE '[0-9]+')
			bus=$(printf "%03d" $bus)
			dev=$(printf "%03d" $dev)

			echo -e "\tbus: $bus"
			echo -e "\tdev: $dev"

			# resp=$(lsusb|grep LG|awk '{print $2, $4}'|grep "$bus $dev")
			# if [ -z "$resp" ];then
			# 	echo -e "\tNot found, detaching."
			# 	detachDevice $dev $bus
			# fi

			echo ""
		fi
	done
done
