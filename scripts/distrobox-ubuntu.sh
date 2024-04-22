#!/usr/bin/env sh
#
distrobox create -i ubuntu:latest --name ubuntu --additional-packages "systemd libpam-systemd neovim git ssh openssh-client" --init
