FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y \
    git \
    meson \
    build-essential \
    libglib2.0-dev \
    libssl-dev \
    libncurses-dev && \
    git clone https://github.com/irssi/irssi.git /irssi && \
    cd /irssi && \
    meson Build && \
    ninja -C /irssi/Build

WORKDIR /irssi