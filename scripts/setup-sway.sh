#!/usr/bin/env sh

FILE_PATH="/usr/share/wayland-sessions/sway.desktop"

# Use sed to perform the replacement
sudo sed -i 's/^Exec=sway$/Exec=env XDG_CURRENT_DESKTOP=sway dbus-run-session sway/g' "$FILE_PATH"


#FILE_PATH="/usr/share/xdg-desktop-portal/portals/gnome-keyring.portal"

#if [ ! -f "$FILE_PATH" ]; then
#    echo "File $FILE_PATH does not exist."
#    exit 1
#fi

#if grep -q ";sway" "$FILE_PATH"; then
#    echo "';sway' already present in $FILE_PATH"
#else
#    sed -i '/^UseIn=/ s/$/;sway/' "$FILE_PATH"
#    echo "Added ';sway' to $FILE_PATH"
#fi
