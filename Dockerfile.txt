# Etap budowy: budowanie i kompilacja Redis
FROM buildpack-deps:buster AS build

# Instalacja zależności do kompilacji Redis
RUN apt-get update && apt-get install -y \
    tcl \
    build-essential \
    autoconf \
    libjemalloc-dev \
    docker \
    git \
    lua5.3 \
    liblua5.3-dev

# Pobranie i kompilacja Redis
RUN git clone https://github.com/redis/redis.git /app/redis
WORKDIR /app/redis
RUN make

# Etap końcowy: obraz, który będzie zawierał Redis i testy
FROM buildpack-deps:buster

# Instalacja zależności
RUN apt-get update && apt-get install -y \
    tcl \
    docker \
    lua5.3 \
    liblua5.3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Kopiowanie skompilowanego Redis oraz testów
COPY --from=build /app/redis/src/redis-server /usr/local/bin/redis-server
COPY --from=build /app/redis/tests /app/redis/tests
COPY --from=build /app/redis/Makefile /app/redis/Makefile
COPY --from=build /app/redis/src /app/redis/src
COPY --from=build /app/redis/runtest /app/redis/runtest

# Ustawienie katalogu roboczego
WORKDIR /app/redis

# Dodanie uprawnień do wykonania dla runtest
RUN chmod +x ./runtest

# Skrypt powłoki do uruchomienia Redis i testów
COPY run-tests.sh /run-tests.sh
RUN chmod +x /run-tests.sh

# Uruchomienie Redis i testów w jednym kroku
ENTRYPOINT ["/run-tests.sh"]
