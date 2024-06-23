FROM ubuntu

RUN apt-get update && \
    apt-get install -y \
    git \ 
    meson \ 
    build-essential \
    libglib2.0-dev \
    libncurses-dev \
    libssl-dev && \
    git clone https://github.com/irssi/irssi && \
    cd /irssi && \
    meson Build && \
    ninja -C /irssi/Build

WORKDIR /irssi