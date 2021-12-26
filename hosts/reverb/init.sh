alias usys='aurman -Syu --noconfirm'
alias pacman_world='pacman -Qqe | grep -v "$(pacman -Qmq)"'
alias pacman_foreign='pacman -Qqet | grep -v "$(pacman -Qqg base)" | grep -v "$(pacman -Qqm)"'
alias fix_pacman="su -c 'rm -f /var/lib/pacman/db.lck'"
alias mkernel="su -c \"make -j5 ; make modules_install ; cp arch/x86/boot/bzImage /boot/vmlinuz-linux-hexec ; grub-mkconfig -o /boot/grub/grub.cfg ; mkinitcpio -p linux-hexec cd -\""

pacman_deselect() {
    sudo pacman -S --asdeps $@
}

pacman_select() {
    sudo pacman -S --asexplicit $@
}

pacman_list() {
    LC_ALL=C pacman -Qi | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | sort -h
}
