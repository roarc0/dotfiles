export DISPLAY=:1

usys() {
    sudo dnf update && \
    sudo flatpak update && \
    sudo flatpak uninstall --unused
}
