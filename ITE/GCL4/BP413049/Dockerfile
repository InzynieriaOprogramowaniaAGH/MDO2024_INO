# Wybierz obraz bazowy
FROM ubuntu:latest

# Zainstaluj Git
RUN apt-get update && apt-get install -y git

# Ustaw katalog roboczy
WORKDIR /app

# Klonuj repozytorium
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

# Uruchom w trybie interaktywnym
CMD ["bash"]

