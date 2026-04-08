INDENT="%1s"
GOOD=$(printf '\033[32;01m')
WARN=$(printf '\033[33;01m')
BAD=$(printf '\033[31;01m')
NORMAL=$(printf '\033[0m')

ask() {
  while true; do
    read -r "$1? (y/n) " yn
    case $yn in
    [Yy]*)
      return 0
      break
      ;;
    [Nn]*)
      return 1
      break
      ;;
    *) break ;;
    esac
  done
}

echoc() {
  echo -e "\E["$1"m$2\E[0m"
}

einfo() {
  printf "${GOOD}[INFO]${NORMAL}${INDENT}$*\n"
}

ewarn() {
  printf "${WARN}[WARN]${NORMAL}${INDENT}$*\n" >&2
}

eerror() {
  printf "${BAD}[ERROR]${NORMAL}${INDENT}$*\n" >&2
}

run_as_root() {
  if [ $EUID -ne 0 ]; then
    if [ -t 1 ]; then
      sudo "$0" "$*"
    fi
    exit
  fi
}

is_root() {
  if [ $EUID -ne 0 ]; then
    eerror "Please run as root."
    exit $?
  fi
}

is_distro() {
  grep -qi "$1" /etc/os-release
  return $?
}

has_command() {
  type "$1" &>/dev/null
}

action_prefix() {
  local tag="$1"
  local icon=""
  local color=""
  local reset=""
  local color_on=false
  local emoji_on=false

  # Color control:
  # - disable with NO_COLOR
  # - enable with DOTFILES_COLOR=1 / FORCE_COLOR=1 / CLICOLOR_FORCE=1
  # - otherwise auto-detect terminal colors
  if [ -z "${NO_COLOR:-}" ]; then
    if [ "${DOTFILES_COLOR:-}" = "1" ] || [ "${FORCE_COLOR:-}" = "1" ] || [ "${CLICOLOR_FORCE:-}" = "1" ]; then
      color_on=true
    elif command -v tput >/dev/null 2>&1; then
      if [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
        color_on=true
      fi
    fi
  fi

  # Emoji control:
  # - disable with DOTFILES_EMOJI=0
  # - enable with DOTFILES_EMOJI=1
  # - otherwise use UTF-8 locale auto-detection
  if [ "${DOTFILES_EMOJI:-}" = "1" ]; then
    emoji_on=true
  elif [ "${DOTFILES_EMOJI:-}" = "0" ]; then
    emoji_on=false
  else
    case "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" in
    *UTF-8*|*utf8*) emoji_on=true ;;
    esac
  fi

  if [ "$color_on" = true ]; then
      reset=$(printf '\033[0m')
      case "$tag" in
      LINK) color=$(printf '\033[32;1m') ;;
      UNLINK) color=$(printf '\033[33;1m') ;;
      esac
  fi

  if [ "$emoji_on" = true ]; then
    case "$tag" in
    LINK) icon="🔗 " ;;
    UNLINK) icon="🔓 " ;;
    BACKUP) icon="📦 " ;;
    esac
  fi

  printf "%s%s[%s]%s" "$icon" "$color" "$tag" "$reset"
}

install_link() {
  local p_link
  local p_unlink
  local p_backup

  p_link="$(action_prefix LINK)"
  p_unlink="$(action_prefix UNLINK)"
  p_backup="$(action_prefix BACKUP)"

  if [ -h "$2" ]; then
    printf "%s %s\n" "$p_unlink" "$2"
    unlink "$2" >/dev/null
  elif [ -e "$2" ]; then
    printf "%s %s => %s.bak\n" "$p_backup" "$2" "$2"
    mv "$2" "$2.bak"
  fi
  printf "%s %s => %s\n" "$p_link" "$1" "$2"
  ln -sf "$1" "$2"
}
