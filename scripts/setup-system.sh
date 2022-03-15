#!/usr/bin/env sh

cp /usr/share/systemd/tmp.mount /etc/systemd/system/tmp.mount
systemctl enable tmp.mount
systemctl start tmp.mount
