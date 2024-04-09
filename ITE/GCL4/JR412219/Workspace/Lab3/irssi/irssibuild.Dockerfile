FROM fedora:39

WORKDIR /root/Apps

RUN dnf -y update && dnf -y install git gcc meson ninja* glib2-devel utf8proc* perl-Ext* ncurses*
RUN git clone https://github.com/irssi/irssi

WORKDIR /root/Apps/irssi

RUN meson Build && ninja -C Build
