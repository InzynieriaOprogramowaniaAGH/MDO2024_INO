#obraz ubuntu jako baza
FROM ubuntu:latest

#aktualizacja systemu i instalacja gita
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

#ustawienie katalogu roboczego
WORKDIR /app

#Klonowanie repo
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git