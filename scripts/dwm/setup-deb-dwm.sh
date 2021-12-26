#!/usr/bin/env bash

if [ ! -e /usr/share/xsessions/dwm.desktop ]; then
    sudo cp dwm.desktop /usr/share/xsessions/dwm.desktop
fi

sudo apt install build-essential libx11-dev libxinerama-dev sharutils suckless-tools libxft-dev stterm

VERSION="6.2"
SRC_DIR=dwm-$VERSION
SRC_PKG=dwm-$VERSION.tar.gz

if [ ! -f $SRC_PKG ];then
    wget http://dl.suckless.org/dwm/$SRC_PKG
fi

if [ ! -d $SRC_DIR ];then
    tar xvzf $SRC_PKG
    chown -R `id -u`:`id -g` $SRC_DIR
fi

if [ -f config.h ];then
    cp config.h $SRC_DIR
fi

cd $SRC_DIR
sudo make clean install
cd - >/dev/null
