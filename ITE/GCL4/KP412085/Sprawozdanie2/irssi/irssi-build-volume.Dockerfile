FROM fedora:39

RUN --mount=type=cache,target=/var/cache/yum \
 dnf -y update && dnf -y install git meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*

RUN git clone https://github.com/irssi/irssi

WORKDIR /irssi

RUN meson Build

VOLUME /irssi/Build

RUN ninja -C /irssi/Build
