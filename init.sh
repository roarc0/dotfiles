export ENV_HOME="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"

export ANDROID_HOME="$HOME/.local/android/sdk"
export JAVA_HOME="/usr/lib/jvm/default-java/"
export GOPATH="$HOME/.local/go"
export CARGOPATH="$HOME/.cargo"

export PATH="${ENV_HOME}/bin:$PATH"
export PATH="${HOME}/.local/bin:$PATH"
export PATH="${GOPATH}/bin:$PATH"
export PATH="${CARGOPATH}/bin:$PATH"
export PATH="/snap/bin:$PATH"

export GIT_TERMINAL_PROMPT=1
export EDITOR=vim
export VISUAL=$EDITOR
export SYSTEMD_EDITOR=$EDITOR
export DISPLAY=:0
export MERGETOOL=meld
unset SSH_ASKPASS

export ENV_FILE="$ENV_HOME/.env"
if [ -f "$ENV_FILE" ]; then
  . $ENV_FILE
fi

. $ENV_HOME/scripts/aliases.sh
. $ENV_HOME/scripts/functions.sh

export HOST=$(hostname)
HOST_HOME="$ENV_HOME/hosts/$HOST"
if [ -n "$HOST" -a -d $HOST_HOME ]; then
  export PATH="$PATH:$HOST_HOME/bin"
  if [ -f $HOST_HOME/init.sh ]; then
    . $HOST_HOME/init.sh
  fi
fi

# if [[ -n $SSH_CONNECTION ]]; then
# fi
