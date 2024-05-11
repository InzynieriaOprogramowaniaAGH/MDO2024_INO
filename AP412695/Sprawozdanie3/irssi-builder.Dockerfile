FROM fedora

RUN dnf install -y git meson ninja-build net-tools openssl-devel ncurses-devel glib2-devel libgcrypt-devel libotr-devel perl-devel pkg-config utf8proc-devel perl

RUN git clone https://github.com/irssi/irssi

WORKDIR /irssi
RUN meson Build
RUN ninja -C /irssi/Build
RUN ninja -C Build install
