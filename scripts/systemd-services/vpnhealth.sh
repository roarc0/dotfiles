#!/usr/bin/env bash

VPN_GATEWAY=10.66.66.1
VPN_INTERFACE=wg0

ping -c1 -W5 $VPN_GATEWAY 1>/dev/null 2>/dev/null || (wg-quick down $VPN_INTERFACE ; wg-quick up $VPN_INTERFACE)
