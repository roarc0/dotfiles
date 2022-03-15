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

install_link() {
  if [ -h "$2" ]; then
    echo "unlink  $2"
    unlink "$2" >/dev/null
  elif [ -e "$2" ]; then
    echo "backup $2 => $2.bak"
    mv "$2" "$2.bak"
  fi
  echo "link $1 => $2"
  ln -sf "$1" "$2"
}
