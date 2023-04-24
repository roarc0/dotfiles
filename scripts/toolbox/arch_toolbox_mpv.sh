#!/usr/bin/env sh

desktop-file-install --dir=$HOME/.local/share/applications mpv.desktop
update-desktop-database $HOME/.local/share/applications
xdg-desktop-menu forceupdate
