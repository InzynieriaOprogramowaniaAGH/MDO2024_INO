FROM fedora:39
RUN dnf -y update && dnf -y --skip-broken install git meson ninja* gcc glib2* utf8* ncurses* openssl* perl-Ext*
WORKDIR /root/irssi
RUN git clone https://github.com/irssi/irssi .
RUN meson Build
RUN ninja -C /root/irssi/Build && ninja -C Build install
CMD ["irssi"]
