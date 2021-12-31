#!/usr/bin/env bash
set -e
find ${ENV_HOME} -name 'setup-*.sh' # | while read installer ; do sh -c "${installer}" ; done

xdg-mime default org.gnome.Nautilus.desktop inode/directory
