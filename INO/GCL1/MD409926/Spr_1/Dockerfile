# Użyj najnowszego obrazu Ubuntu jako podstawy
FROM ubuntu:latest

# Zaktualizuj listę pakietów i zainstaluj git
RUN apt-get update && apt-get install -y git

# Sklonuj nasze repozytorium
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

# Ustaw katalog roboczy na repozytorium
WORKDIR /repozytorium

# Uruchom w trybie interaktywnym
CMD ["/bin/bash"]
