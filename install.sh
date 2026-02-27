#!/usr/bin/env bash

. env.sh
set -e

echoc 31 "Environment setup ..."
if [ "$USER" = "root" ]; then
  HOME="/root"
fi

mkdir "$HOME"/{workspace,dev,repos,tmp,sync} >/dev/null 2>&1 || true

install_link "$ENV_HOME/dotfiles/zshrc" "$HOME/.zshrc"
install_link "$ENV_HOME/dotfiles/p10k.zsh" "$HOME/.p10k.zsh"
install_link "$ENV_HOME/dotfiles/bashrc" "$HOME/.bashrc"
install_link "$ENV_HOME/dotfiles/gitconfig" "$HOME/.gitconfig"
install_link "$ENV_HOME/dotfiles/profile" "$HOME/.profile"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  mkdir -p "$HOME"/.local/share/{icons,fonts} >/dev/null 2>&1 || true
  install_link "$ENV_HOME/dotfiles/profile" "$HOME/.profile"
  install_link "$ENV_HOME/dotfiles/local/share/icons" "$HOME/.local/share/icons"
  install_link "$ENV_HOME/dotfiles/local/share/fonts" "$HOME/.local/share/fonts"

  chattr +i "$HOME/.config/user-dirs.dirs" || true
  install_link "$ENV_HOME/dotfiles/config/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
  chattr -i "$HOME/.config/user-dirs.dirs" || true
  install_link "$ENV_HOME/dotfiles/config/user-dirs.locale" "$HOME/.config/user-dirs.locale"
  install_link "$ENV_HOME/dotfiles/config/vscode/settings.json" "$HOME/.config/Code/User/settings.json" || true
  setup-folder-icons
fi

DOTFILES="$ENV_HOME/dotfiles"
if [[ "$OSTYPE" == "darwin"* ]]; then
  CONFIG_DIR="$HOME/Library/Application Support"
else
  CONFIG_DIR="$HOME/.config"
fi

for SRC in "$DOTFILES"/config/*; do
  DEST="$CONFIG_DIR/$(basename "$SRC")"
  install_link "$SRC" "$DEST"
done

. scripts/setup-oh-my-zsh.sh