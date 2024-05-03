# Instrukcje instalacji

Aby zainstalować niezbędne zależności w obrazie ubuntu do uruchomienia pliku wykonywalnego irssi, wykonaj następujące polecenia:

```bash
apt-get update \
    && apt-get install -y libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*
```