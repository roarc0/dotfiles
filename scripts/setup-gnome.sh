#!/usr/bin/env sh

gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

gsettings set org.gnome.desktop.interface show-battery-percentage true

gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 3600

gsettings org.gnome.nautilus.preferences click-policy 'single'
gsettings org.gnome.nautilus.preferences always-use-location-entry true
gsettings org.gnome.nautilus.preferences show-create-link true
gsettings org.gnome.nautilus.compression default-compression-format 'tar.xz'

xdg-mime default org.gnome.Nautilus.desktop inode/directory
