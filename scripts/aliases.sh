alias ...='cd ../..'
alias ..='cd ..'
alias mkdir='mkdir -p'
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
alias shell='echo -e ${SHELL}'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias tl="tail -f"
alias du='du -kh'
alias df='df -kTh'
alias mtop="ps --no-header -eo pmem,size,vsize,comm | sort -nr | sed 10q"
alias ctop="ps --no-header -eo pcpu,comm | sort -nr | sed 10q"
alias memrss='while read command percent rss; do if [[ "${command}" != "COMMAND" ]]; then rss="$(bc <<< "scale=2;${rss}/1024")"; fi; printf "%-26s%-8s%s\n" "${command}" "${percent}" "${rss}"; done < <(ps -A --sort -rss -o comm,pmem,rss | head -n 11)'
alias millis='date +%s%3N'
alias gitignore-sort='sort -u .gitignore -o .gitignore'

#system
alias reboot='sudo systemctl reboot'
alias poweroff='sudo systemctl poweroff'
alias suspend='sudo systemctl suspend'
alias drop-caches="su -c \"sync; echo 3 > /proc/sys/vm/drop_caches && swapoff -a ; swapon -a\""
alias grub-update='su -c "mount /boot/ ; grub-mkconfig -o /boot/grub/grub.cfg"'
alias gedit='gnome-text-editor'
