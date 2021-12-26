export EIX_LIMIT=0
export EIX_LIMIT_COMPACT=0

alias uadnv="sudo emerge -uaDNv --backtrack=5 --keep-going world"
alias udnv="sudo emerge -uDNv --backtrack=5 --keep-going world"

alias wmerge="watch -c genlop -ce"
alias fmerge="sudo tail -f /var/log/emerge-fetch.log"
alias lmerge='cat /var/log/emerge.log | grep "completed emerge"'
alias nmerge="sudo emerge -1av $(find /var/db/pkg/ -mindepth 2 -maxdepth 3 -name \*9999 | awk -F \/ '{printf "=%s/%s ", $5, $6}')"

alias copyconf='su -c "zcat /proc/config.gz > /usr/src/linux/.config"'
alias mkernel="su -c \"mount /boot ; cd /usr/src/linux ; make -j5 ; make install; make modules -j5 ; make modules_install ; grub-mkconfig -o /boot/grub/grub.cfg ; cd - ; emerge -1O @kernel-modules\""
