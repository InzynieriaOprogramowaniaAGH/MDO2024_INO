FROM fedora:39

RUN --mount=type=cache,target=/var/cache/dnf \
 dnf -y update && dnf -y install git meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*

# 1 opcja (pobieramy repozytorium)
#RUN git clone https://github.com/irssi/irssi

# 2 opcja (bindujemy wolumen z istniejącym repozytorium na hoscie)
# opcja rw - read/write, ENV musi zostac podany jako parametr przy budowaniu
ARG HOME=$HOME

RUN mkdir -p /irssi && --mount=type=bind,source=$HOME/irssi/,target=/irssi,rw

WORKDIR /irssi

RUN meson Build && ninja -C /irssi/Build
