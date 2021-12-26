#!/usr/bin/env sh
mkdir autoload >/dev/null
cd autoload
rm plug.vim
wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cd -
