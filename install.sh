#!/usr/bin/env bash

. env.sh
set -e

# Parse arguments
UNINSTALL=false
while [[ $# -gt 0 ]]; do
  case $1 in
    --uninstall) UNINSTALL=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

echoc 31 "Environment setup ($([ "$UNINSTALL" = true ] && echo "UNINSTALL" || echo "INSTALL")) ..."
[ "$USER" = "root" ] && HOME="/root"

# Detect OS
IS_LINUX=false
IS_MACOS=false
[[ "$OSTYPE" == "linux-gnu"* ]] && IS_LINUX=true
[[ "$OSTYPE" == "darwin"* ]] && IS_MACOS=true

uninstall_link() {
  if [ -L "$2" ]; then
    echo "unlink $2"
    unlink "$2" >/dev/null
  fi
}

# If uninstall mode, remove symlinks and exit
if [ "$UNINSTALL" = true ]; then
  einfo "Removing symlinks..."
  uninstall_link "$ENV_HOME/dotfiles/zshrc" "$HOME/.zshrc"
  uninstall_link "$ENV_HOME/dotfiles/p10k.zsh" "$HOME/.p10k.zsh"
  uninstall_link "$ENV_HOME/dotfiles/bashrc" "$HOME/.bashrc"
  uninstall_link "$ENV_HOME/dotfiles/gitconfig" "$HOME/.gitconfig"
  uninstall_link "$ENV_HOME/dotfiles/profile" "$HOME/.profile"
  
  if $IS_LINUX; then
    uninstall_link "$ENV_HOME/dotfiles/local/share/icons" "$HOME/.local/share/icons"
    uninstall_link "$ENV_HOME/dotfiles/local/share/fonts" "$HOME/.local/share/fonts"
    uninstall_link "$ENV_HOME/dotfiles/config/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
    uninstall_link "$ENV_HOME/dotfiles/config/user-dirs.locale" "$HOME/.config/user-dirs.locale"
  fi
  
  DOTFILES="$ENV_HOME/dotfiles"
  CONFIG_DIR="$($IS_MACOS && echo "$HOME/Library/Application Support" || echo "$HOME/.config")"
  for SRC in "$DOTFILES"/config/*; do
    DEST="$CONFIG_DIR/$(basename "$SRC")"
    uninstall_link "$SRC" "$DEST"
  done
  
  einfo "Uninstall complete. Config files preserved in $DOTFILES"
  exit 0
fi

# Normal install mode
[ -d "$HOME"/{workspace,dev,repos,tmp,sync} ] || mkdir -p "$HOME"/{workspace,dev,repos,tmp,sync} >/dev/null 2>&1 || true

# Link shell configs (common to all Unix)
install_link "$ENV_HOME/dotfiles/zshrc" "$HOME/.zshrc"
install_link "$ENV_HOME/dotfiles/p10k.zsh" "$HOME/.p10k.zsh"
install_link "$ENV_HOME/dotfiles/bashrc" "$HOME/.bashrc"
install_link "$ENV_HOME/dotfiles/gitconfig" "$HOME/.gitconfig"
install_link "$ENV_HOME/dotfiles/profile" "$HOME/.profile"

# macOS: also link ~/.zprofile to ensure profile is sourced before zshrc
if $IS_MACOS && [ ! -f "$HOME/.zprofile" ]; then
  cat > "$HOME/.zprofile" << 'EOF'
# macOS zprofile: ensure profile is sourced
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
EOF
  echo "created $HOME/.zprofile"
fi

# OS-specific setup
if $IS_LINUX; then
  mkdir -p "$HOME"/.local/share/{icons,fonts} >/dev/null 2>&1 || true
  install_link "$ENV_HOME/dotfiles/local/share/icons" "$HOME/.local/share/icons"
  install_link "$ENV_HOME/dotfiles/local/share/fonts" "$HOME/.local/share/fonts"

  # Linux XDG user directories
  chattr +i "$HOME/.config/user-dirs.dirs" >/dev/null 2>&1 || true
  install_link "$ENV_HOME/dotfiles/config/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
  chattr -i "$HOME/.config/user-dirs.dirs" >/dev/null 2>&1 || true
  install_link "$ENV_HOME/dotfiles/config/user-dirs.locale" "$HOME/.config/user-dirs.locale"

  # VSCode on Linux
  if [ -d "$HOME/.config/Code/User" ]; then
    install_link "$ENV_HOME/dotfiles/config/vscode/settings.json" "$HOME/.config/Code/User/settings.json" || true
  fi

  # Apply folder icons if available
  type setup-folder-icons >/dev/null 2>&1 && setup-folder-icons || true
fi

if $IS_MACOS; then
  mkdir -p "$HOME/Library/Application Support" >/dev/null 2>&1 || true
  # macOS VSCode location
  if [ -d "$HOME/Library/Application Support/Code/User" ]; then
    install_link "$ENV_HOME/dotfiles/config/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json" || true
  fi
  
  # Add Homebrew paths early (Apple Silicon and Intel)
  if [ -x /opt/homebrew/bin/brew ] || [ -x /usr/local/bin/brew ]; then
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
  fi
fi

# Link generic config files with OS-aware CONFIG_DIR
DOTFILES="$ENV_HOME/dotfiles"
CONFIG_DIR="$($IS_MACOS && echo "$HOME/Library/Application Support" || echo "$HOME/.config")"
mkdir -p "$CONFIG_DIR" >/dev/null 2>&1 || true

for SRC in "$DOTFILES"/config/*; do
  DEST="$CONFIG_DIR/$(basename "$SRC")"
  install_link "$SRC" "$DEST"
done

# Validate bin script dependencies
einfo "Checking bin script dependencies..."
cd "$ENV_HOME/bin" 2>/dev/null || exit 0
for script in convert-*; do
  [ -x "$script" ] || continue
  case "$script" in
    convert-epub*) type calibre >/dev/null 2>&1 || ewarn "[$script] requires calibre" ;;
    convert-*-pdf|convert-svg*) type inkscape >/dev/null 2>&1 || ewarn "[$script] requires inkscape" ;;
    convert-flac*) type ffmpeg >/dev/null 2>&1 || ewarn "[$script] requires ffmpeg" ;;
    convert-merge-pdf) type pdftk >/dev/null 2>&1 || ewarn "[$script] requires pdftk" ;;
  esac
done

# Shell initialization
. "$ENV_HOME"/scripts/setup-oh-my-zsh.sh

# Optional: apply macOS defaults if script exists
if $IS_MACOS && [ -x "$ENV_HOME/scripts/setup-macos-defaults.sh" ]; then
  read -p "Apply macOS system defaults? (y/n) " -n 1 -r
  echo
  [ "$REPLY" = "y" ] && "$ENV_HOME/scripts/setup-macos-defaults.sh"
fi

echoc 32 "✓ Setup complete"