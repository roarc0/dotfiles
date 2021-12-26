#!/usr/bin/env bash
set -e

apt install wayland-protocols \
libwayland-dev \
libegl1-mesa-dev \
libgles2-mesa-dev \
libdrm-dev \
libgbm-dev \
libinput-dev \
libxkbcommon-dev \
libgudev-1.0-dev \
libpixman-1-dev \
libsystemd-dev \
cmake \
libpng-dev \
libavutil-dev \
libavcodec-dev \
libavformat-dev \
ninja-build \

pip3 install meson

apt install libxcb-composite0-dev \
    libxcb-present-dev \
    libxcb-dri3-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-render0-dev \
    libxcb-xfixes0-dev \
    libxkbcommon-dev \
    libxcb-xinput-dev \
    libx11-xcb-dev

rm -rf ~/sway-build
mkdir -p ~/sway-build
cd ~/sway-build
git clone https://github.com/swaywm/wlroots.git || true
cd wlroots
git checkout 0.14.0
meson build
ninja -C build
ninja -C build install

cd ..

apt install libjson-c-dev \
libpango1.0-dev \
libcairo2-dev \
libgdk-pixbuf2.0-dev \
scdoc

git clone https://github.com/swaywm/sway.git || true
cd sway
git checkout 1.6.1
meson build
ninja -C build
ninja -C build install

cd -

tee -a /usr/local/share/wayland-sessions/sway.desktop << END
[Desktop Entry]
Name=Sway
Comment=An i3-compatible Wayland compositor
Exec=sway --my-next-gpu-wont-be-nvidia
Type=Application
END

apt install foot foot-terminfo suckless-tools sway-backgrounds swaybg
