alias tl="tail -f"
alias mkdir='mkdir -p'
alias ...='cd ../..'
alias ..='cd ..'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias e="$EDITOR"
alias v="$VISUAL"
alias l='ls -CF'
alias ll='ls -lahF --color=always'
alias ls='ls --color=always'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias du='du -kh'
alias df='df -kTh'

# job control
alias mtop="ps --no-header -eo pmem,size,vsize,comm | sort -nr | sed 10q"
alias ctop="ps --no-header -eo pcpu,comm | sort -nr | sed 10q"
alias memrss='while read command percent rss; do if [[ "${command}" != "COMMAND" ]]; then rss="$(bc <<< "scale=2;${rss}/1024")"; fi; printf "%-26s%-8s%s\n" "${command}" "${percent}" "${rss}"; done < <(ps -A --sort -rss -o comm,pmem,rss | head -n 11)'

#system
alias reboot='sudo systemctl reboot'
alias poweroff='sudo systemctl poweroff'
alias suspend='sudo systemctl suspend'
alias drop-caches="su -c \"sync; echo 3 > /proc/sys/vm/drop_caches && swapoff -a ; swapon -a\""
alias grub-update='su -c "mount /boot/ ; grub-mkconfig -o /boot/grub/grub.cfg"'
alias ucode='sudo iucode_tool -L /lib/firmware/intel-ucode | grep 206a7 -B 1'

alias k='kubectl'
alias dk='docker'

alias docker-clean=' \
  docker ps --no-trunc -aqf "status=exited" | xargs docker rm ; \
  docker images --no-trunc -aqf "dangling=true" | xargs docker rmi ; \
  docker volume ls -qf "dangling=true" | xargs docker volume rm'
alias docker-clean-hard=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '
alias docker-clean-images='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias docker-clean-1m=' \
  docker images --no-trunc --format \"{{.ID}} {{.CreatedSince}}\" \
    | grep \" months\" | awk \"{ print $1 }\" \
    | xargs --no-run-if-empty docker rmi'
alias docker-stop-all='docker kill $(docker ps -q)'
