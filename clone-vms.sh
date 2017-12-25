#!/bin/bash

set -x

IMAGES_PATH="/home/kirimaks/Qemu/images"
mkdir -p $IMAGES_PATH


for i in {1..4}; do
	virt-clone --original Proxy0 --name Proxy$i --file $IMAGES_PATH/proxy$i.img --check all=off
	virsh start Proxy$i
	virsh autostart Proxy$i
done
