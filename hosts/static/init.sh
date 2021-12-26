export DISPLAY=:1

usys() {
    sudo apt update && \
    sudo apt full-upgrade && \
    sudo apt autoremove --purge && \
    sudo snap refresh && remove-old-snaps && \
    sudo flatpak update && sudo flatpak uninstall --unused && \
    flatpak --user update && flatpak --user uninstall --unused
}

uclean() {
    echoc 31 "cleaning apt cache"
    sudo du -sh /var/cache/apt
    sudo apt clean
    echoc 31 "cleaning thumbnails"
    du -sh ~/.cache/thumbnails
    rm -rf "~/.cache/thumbnails/*"
    sudo journalctl --vacuum-time=10d
    echoc 31 "orphaned packages : "
    sudo deborphan

    docker images -f dangling=true | awk '{print $3}' | xargs docker rmi
}
