#!/usr/bin/env sh
podman pull docker.io/archlinux/archlinux:latest
cat arch.dockerfile | podman build -t arch-toolbox -

toolbox create --image arch-toolbox

toolbox run -c arch-toolbox pacman -Syu git zsh net-tools neovim
