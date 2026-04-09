#!/usr/bin/env bash

set -e

ENV_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. "$ENV_HOME/scripts/functions.sh"

# Parse arguments
UNINSTALL=false
DRY_RUN=false
while [[ $# -gt 0 ]]; do
  case $1 in
    --uninstall) UNINSTALL=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) ewarn "Unknown option: $1"; exit 1 ;;
  esac
done

MODE="$([ "$UNINSTALL" = true ] && echo "UNINSTALL" || echo "INSTALL")"
[ "$DRY_RUN" = true ] && MODE="$MODE DRY-RUN"
einfo "Environment setup (${MODE})"
[ "$USER" = "root" ] && HOME="/root"

# Detect OS
IS_LINUX=false
IS_MACOS=false
[[ "$OSTYPE" == "linux-gnu"* ]] && IS_LINUX=true
[[ "$OSTYPE" == "darwin"* ]] && IS_MACOS=true

# If uninstall mode, remove symlinks and exit
if [ "$UNINSTALL" = true ]; then
  einfo "Removing symlinks"
  unlink_or_print "$HOME/.zshrc"
  unlink_or_print "$HOME/.p10k.zsh"
  unlink_or_print "$HOME/.bashrc"
  unlink_or_print "$HOME/.gitconfig"
  unlink_or_print "$HOME/.profile"

  if $IS_LINUX; then
    unlink_or_print "$HOME/.local/share/icons"
    unlink_or_print "$HOME/.local/share/fonts"
    unlink_or_print "$HOME/.config/user-dirs.dirs"
    unlink_or_print "$HOME/.config/user-dirs.locale"
  fi

  DOTFILES="$ENV_HOME/dotfiles"
  CONFIG_DIR="$($IS_MACOS && echo "$HOME/Library/Application Support" || echo "$HOME/.config")"
  for SRC in "$DOTFILES"/config/*; do
    DEST="$CONFIG_DIR/$(basename "$SRC")"
    unlink_or_print "$DEST"
  done

  eok "Uninstall complete. Config files preserved in $DOTFILES"
  exit 0
fi

# Normal install mode
run_or_print "mkdir -p $HOME/{workspace,dev,repos,tmp,sync}" mkdir -p "$HOME"/{workspace,dev,repos,tmp,sync}

# Link shell configs (common to all Unix)
link_or_print "$ENV_HOME/dotfiles/zshrc" "$HOME/.zshrc"
link_or_print "$ENV_HOME/dotfiles/p10k.zsh" "$HOME/.p10k.zsh"
link_or_print "$ENV_HOME/dotfiles/bashrc" "$HOME/.bashrc"
link_or_print "$ENV_HOME/dotfiles/gitconfig" "$HOME/.gitconfig"
link_or_print "$ENV_HOME/dotfiles/profile" "$HOME/.profile"

# macOS: also link ~/.zprofile to ensure profile is sourced before zshrc
if $IS_MACOS && [ ! -f "$HOME/.zprofile" ]; then
  if [ "$DRY_RUN" = true ]; then
    edry "create $HOME/.zprofile"
  else
    cat > "$HOME/.zprofile" << 'EOF'
# macOS zprofile: ensure profile is sourced
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
EOF
    echo "created $HOME/.zprofile"
  fi
fi

# OS-specific setup
if $IS_LINUX; then
  run_or_print "mkdir -p $HOME/.local/share/{icons,fonts}" mkdir -p "$HOME"/.local/share/{icons,fonts}
  link_or_print "$ENV_HOME/dotfiles/local/share/icons" "$HOME/.local/share/icons"
  link_or_print "$ENV_HOME/dotfiles/local/share/fonts" "$HOME/.local/share/fonts"

  # Linux XDG user directories
  if [ "$DRY_RUN" = true ]; then
    edry "chattr +i $HOME/.config/user-dirs.dirs"
  else
    chattr +i "$HOME/.config/user-dirs.dirs" >/dev/null 2>&1 || true
  fi
  link_or_print "$ENV_HOME/dotfiles/config/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
  if [ "$DRY_RUN" = true ]; then
    edry "chattr -i $HOME/.config/user-dirs.dirs"
  else
    chattr -i "$HOME/.config/user-dirs.dirs" >/dev/null 2>&1 || true
  fi
  link_or_print "$ENV_HOME/dotfiles/config/user-dirs.locale" "$HOME/.config/user-dirs.locale"

  # VSCode on Linux
  if [ -d "$HOME/.config/Code/User" ] && [ ! -d "$ENV_HOME/dotfiles/config/Code" ]; then
    link_or_print "$ENV_HOME/dotfiles/config/vscode/settings.json" "$HOME/.config/Code/User/settings.json" || true
  fi

  # Apply folder icons if available
  if [ "$DRY_RUN" = true ]; then
    edry "setup-folder-icons"
  else
    type setup-folder-icons >/dev/null 2>&1 && setup-folder-icons || true
  fi
fi

if $IS_MACOS; then
  run_or_print "mkdir -p $HOME/Library/Application Support" mkdir -p "$HOME/Library/Application Support"
  # macOS VSCode location
  if [ -d "$HOME/Library/Application Support/Code/User" ] && [ ! -d "$ENV_HOME/dotfiles/config/Code" ]; then
    link_or_print "$ENV_HOME/dotfiles/config/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json" || true
  fi

  # Add Homebrew paths early (Apple Silicon and Intel)
  if [ -x /opt/homebrew/bin/brew ] || [ -x /usr/local/bin/brew ]; then
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
  fi
fi

# Link generic config files with OS-aware CONFIG_DIR
DOTFILES="$ENV_HOME/dotfiles"
CONFIG_DIR="$($IS_MACOS && echo "$HOME/Library/Application Support" || echo "$HOME/.config")"
run_or_print "mkdir -p $CONFIG_DIR" mkdir -p "$CONFIG_DIR"

for SRC in "$DOTFILES"/config/*; do
  DEST="$CONFIG_DIR/$(basename "$SRC")"
  link_or_print "$SRC" "$DEST"
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
if [ "$DRY_RUN" = true ]; then
  edry "source $ENV_HOME/scripts/setup-oh-my-zsh.sh"
else
  . "$ENV_HOME"/scripts/setup-oh-my-zsh.sh
fi

# Optional: apply macOS defaults if script exists
if $IS_MACOS && [ -x "$ENV_HOME/os/macos/bin/macos-apply-defaults" ]; then
  if [ "$DRY_RUN" = true ]; then
    edry "optional: $ENV_HOME/os/macos/bin/macos-apply-defaults"
  else
    read -p "Apply macOS system defaults? (y/n) " -n 1 -r
    echo
    [ "$REPLY" = "y" ] && "$ENV_HOME/os/macos/bin/macos-apply-defaults"
  fi
fi

eok "Setup complete"