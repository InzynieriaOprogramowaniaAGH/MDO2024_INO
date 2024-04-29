FROM ubuntu

RUN apt-get update && apt-get install -y git meson ninja-build net-tools libc6-dev dpkg-dev libssl-dev libncurses-dev libglib2.0-dev libgcrypt20-dev libotr5-dev libperl-dev pkg-config

RUN git clone https://github.com/irssi/irssi

WORKDIR /irssi
RUN meson Build
RUN ninja -C /irssi/Build