FROM fedora:latest as fedora-build-image

RUN dnf install -y git && \
git clone https://github.com/irssi/irssi

WORKDIR /irssi 

RUN dnf install -y meson ninja* gcc  glib2-devel utf8proc* ncurses* perl-Ext*

RUN meson build && \
ninja -C ./build



