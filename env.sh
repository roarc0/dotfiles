#!/usr/bin/env sh
# shellcheck disable=SC1091

ENV_HOME="$(
  cd "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"
export ENV_HOME

export PATH="${ENV_HOME}/bin:$PATH"
export PATH="$HOME/.local/share/flatpak/exports/bin:/var/lib/flatpak/exports/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

ENV_FILE="$ENV_HOME/.env"
if [ -f "$ENV_FILE" ]; then
  . "$ENV_FILE"
fi
export ENV_FILE

. ~/.profile
. "$ENV_HOME"/scripts/aliases.sh
. "$ENV_HOME"/scripts/docker.sh
. "$ENV_HOME"/scripts/k8s.sh
. "$ENV_HOME"/scripts/functions.sh

HOST="$(hostname)"
export HOST

HOST_HOME="$ENV_HOME/hosts/$HOST"
if [ -n "$HOST" ] && [ -d "$HOST_HOME" ]; then
  if [ -d "$HOST_HOME/bin" ]; then
    export PATH="$PATH:$HOST_HOME/bin"
  fi
  if [ -f "$HOST_HOME/profile" ]; then
    . "$HOST_HOME"/profile
  fi
fi

# if [[ -n $SSH_CONNECTION ]]; then
# fi
