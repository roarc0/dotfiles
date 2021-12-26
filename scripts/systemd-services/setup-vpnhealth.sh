#!/usr/bin/env bash

SERVICE=vpnhealth

cp $SERVICE.service /etc/systemd/system/
cp $SERVICE.timer /etc/systemd/system/

mkdir -p /usr/local/bin/
cp $SERVICE.sh /usr/local/bin
chmod +x /usr/local/bin/$SERVICE.sh

systemctl enable $SERVICE.service $SERVICE.timer
