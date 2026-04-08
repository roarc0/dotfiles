FROM docker.io/archlinux/archlinux:latest
ENV NAME=arch-toolbox VERSION=rolling
LABEL com.github.containers.toolbox="true" \
  name="$NAME" \
  version="$VERSION"
RUN pacman -Syu --noconfirm \
  && pacman -S sudo --noconfirm \
  && pacman -Scc --noconfirm \
  && echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox
CMD ["bash"]
