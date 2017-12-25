#!/bin/bash

lsusb -t |grep "If 0, Class=Communication" | awk '{print $2, $3, $4, $5}'
