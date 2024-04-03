FROM fedora

RUN mkdir /input
RUN mkdir /output
RUN --mount type=bind,source=/var/lib/docker/volumes/volume_in,target=/input
RUN --mount type=bind,source=v/var/lib/docker/volumes/volume_out,target=/output
RUN dnf -y update && \
    dnf -y install git gcc meson ninja* glib2-devel utf8proc-devel ncurses* perl-Ext*
WORKDIR /input
RUN git clone https://github.com/irssi/irssi
WORKDIR /input/irssi
RUN meson Build
RUN ninja -C Build
RUN cp -r build ../../output