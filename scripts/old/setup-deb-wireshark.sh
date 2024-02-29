#!/usr/bin/env sh

sudo dpkg-reconfigure wireshark-common
sudo gpasswd -a "$USER" wireshark
sudo setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/dumpcap
