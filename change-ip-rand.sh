#!/bin/bash

set -x

sleep $(expr $RANDOM % 180) # health checker may still work.
source /etc/profile.d/proxy.sh

me=$(basename "$0")

logger -t $me "Changing ip ($num)"
$PROXY_SCRIPTS/change-ip.sh
