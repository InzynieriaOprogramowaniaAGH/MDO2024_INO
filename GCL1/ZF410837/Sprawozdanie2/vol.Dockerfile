FROM ubuntu:latest

# Instalacja wymaganych narzędzi
RUN apt-get update && apt-get install -y \
    git \
    meson \
    ninja-build \
    glib2.0 \
    libncurses5 \
    libncurses5-dev \
    perl

# Katalogi na wolumeny wejściowy i wyjściowy
RUN mkdir -p /input_volume /output_volume

# Przygotowanie wolumenów
VOLUME /input_volume_dock /output_volume_dock

# Ustawienie katalogu roboczego na wolumenie wejściowym
WORKDIR /input_volume

# Klonowanie na wolumen wejściowy
RUN git clone https://github.com/irssi/irssi .

RUN meson Build && ninja -C /irssi/Build

# Kopiowanie build do wolumenu wyjściowego
RUN cp -r /input_volume/Build /output_volume_dock

