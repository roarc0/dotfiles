export ENV_HOME="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"

export PATH="${ENV_HOME}/bin:$PATH"

export ENV_FILE="$ENV_HOME/.env"
if [ -f $ENV_FILE ]; then
  . $ENV_FILE
fi

. ~/.profile
. $ENV_HOME/scripts/aliases.sh
. $ENV_HOME/scripts/docker.sh
. $ENV_HOME/scripts/functions.sh

export HOST=$(hostname)
HOST_HOME="$ENV_HOME/hosts/$HOST"
if [ -n "$HOST" -a -d $HOST_HOME ]; then
  if [ -d $HOST_HOME/bin ]; then
    export PATH="$PATH:$HOST_HOME/bin"
  fi
  if [ -f $HOST_HOME/profile ]; then
    . $HOST_HOME/profile
  fi
fi

# if [[ -n $SSH_CONNECTION ]]; then
# fi
