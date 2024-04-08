FROM fedora

RUN dnf -y update && \
    dnf -y install git gcc meson ninja* glib2-devel utf8proc-devel ncurses* perl-Ext*

RUN git clone https://github.com/irssi/irssi
WORKDIR /irssi
RUN meson Build 
RUN ninja -C Build