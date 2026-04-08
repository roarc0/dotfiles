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

# Load host-specific profile if available
HOST="$(hostname)"
export HOST

if [ -n "$HOST" ] && [ -d "$ENV_HOME/hosts/$HOST" ]; then
  [ -d "$ENV_HOME/hosts/$HOST/bin" ] && export PATH="${ENV_HOME}/hosts/$HOST/bin:${PATH}"
  [ -f "$ENV_HOME/hosts/$HOST/profile" ] && . "$ENV_HOME/hosts/$HOST/profile"
fi
