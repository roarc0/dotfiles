#!/usr/bin/env sh

mkdir -p $HOME/.npm >/dev/null 2>&1 || true

install_link "$ENV_HOME/dotfiles/npm/package.json" "$HOME/.npm/package.json"

cd $HOME/.npm || true
npm i
cd - || true
