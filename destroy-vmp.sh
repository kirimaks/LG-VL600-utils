#!/bin/bash

set -x

IMAGES_PATH="/home/kirimaks/Qemu/images"
mkdir -p $IMAGES_PATH


for i in {1..3}; do
	virsh destroy Proxy$i
	virsh undefine Proxy$i
done
