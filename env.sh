#!/usr/bin/env sh

ENV_HOME="$(
  cd "$(dirname "$0")" >/dev/null 2>&1 || exit 1
  pwd -P
)" || exit 1
export ENV_HOME

# macOS: Add Homebrew paths early (Apple Silicon + Intel)
if [ -d /opt/homebrew/bin ]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
fi
if [ -d /usr/local/opt ]; then
  export PATH="/usr/local/bin:/usr/local/sbin:${PATH}"
fi

export PATH="${ENV_HOME}/bin:${PATH}"

# Load optional .env file
ENV_FILE="$ENV_HOME/.env"
[ -f "$ENV_FILE" ] && . "$ENV_FILE"
export ENV_FILE

# Load local customizations and functions (before system defaults)
for script in aliases.sh aliases-k8s.sh aliases-docker.sh functions.sh; do
  [ -f "$ENV_HOME/scripts/$script" ] && . "$ENV_HOME/scripts/$script"
done

# Load system defaults last
[ -f "$HOME/.profile" ] && . "$HOME/.profile"

# Detect OS and load OS-specific profile
# Contract:
# - macOS: load os/macos/profile (+ os/macos/bin)
# - Linux: always load os/linux/profile first (+ os/linux/bin)
#           then optionally load os/<distro>/profile (+ os/<distro>/bin)
OS_PROFILE=""
OS_PROFILE_EXTRA=""
ENV_OS="unknown"
ENV_DISTRO="unknown"
case "$OSTYPE" in
  darwin*)
    ENV_OS="macos"
    ENV_DISTRO="macos"
    OS_PROFILE="$ENV_HOME/os/macos/profile"
    [ -d "$ENV_HOME/os/macos/bin" ] && export PATH="${ENV_HOME}/os/macos/bin:${PATH}"
    ;;
  linux*)
    ENV_OS="linux"
    OS_PROFILE="$ENV_HOME/os/linux/profile"
    [ -d "$ENV_HOME/os/linux/bin" ] && export PATH="${ENV_HOME}/os/linux/bin:${PATH}"

    # Detect Linux distro override
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      DISTRO_ID="${ID:-linux}"
      ENV_DISTRO="$DISTRO_ID"
      if [ -d "$ENV_HOME/os/$DISTRO_ID" ]; then
        OS_PROFILE_EXTRA="$ENV_HOME/os/$DISTRO_ID/profile"
        [ -d "$ENV_HOME/os/$DISTRO_ID/bin" ] && export PATH="${ENV_HOME}/os/$DISTRO_ID/bin:${PATH}"
      fi
    fi
    ;;
esac
export ENV_OS
export ENV_DISTRO

# Load OS-specific profile if it exists
[ -f "$OS_PROFILE" ] && . "$OS_PROFILE"
[ -f "$OS_PROFILE_EXTRA" ] && . "$OS_PROFILE_EXTRA"
