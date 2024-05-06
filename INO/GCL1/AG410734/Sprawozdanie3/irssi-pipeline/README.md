# Pochodzenie aplikacji 

Repozytorium https://github.com/irssi/irssi.git


# Biblioteki użyte do zbudowania aplikacji irssi

```
apt-get update && \
apt-get install -y \
git \
meson \
build-essential \
libglib2.0-dev \
libssl-dev \
libncurses-dev && \
```

# Instrukcja wdrożenia

Aby zainstalować niezbędne zależności w ubuntu do uruchomienia pliku wykonywalnego irssi, wykonaj następujące polecenia:

```bash
apt-get update \
&& apt-get install -y libglib2.0-0 \
```