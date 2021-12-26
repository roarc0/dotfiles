#!/bin/sh
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
polybar -c ~/.config/sway/polybar.conf top &

#while :; do
#	date +'%d-%m-%Y %_H:%M:%S'
#	sleep 1
#done
