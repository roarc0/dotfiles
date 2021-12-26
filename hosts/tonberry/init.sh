export DISPLAY=:1

usys() {
    sudo apt update && \
    sudo apt upgrade && \
    sudo apt autoremove --purge && \
    sudo snap refresh && \
    sudo flatpak update && \
    sudo flatpak uninstall --unused
}

ustat() {
    systemctl --failed
    journalctl -p3 -xb
}

uclean() {
    echoc 31 "cleaning apt cache"
    sudo du -sh /var/cache/apt
    sudo apt clean
    echoc 31 "cleaning thumbnails"
    du -sh ~/.cache/thumbnails
    rm -rf "~/.cache/thumbnails/*"
    journalctl --vacuum-time=10d
    echoc 31 "orphaned packages : "
    deborphan

    docker images -f dangling=true | awk '{print $3}' | xargs docker rmi
}
