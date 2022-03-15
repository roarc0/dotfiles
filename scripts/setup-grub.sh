#!/usr/bin/env sh

GRUB_CONFIG="/etc/default/grub"
[ -f $GRUB_CONFIG ] && sed -i 's/GRUB_TIMEOUT=[0-9]\+/GRUB_TIMEOUT=2/g' $GRUB_CONFIG
update-grub
