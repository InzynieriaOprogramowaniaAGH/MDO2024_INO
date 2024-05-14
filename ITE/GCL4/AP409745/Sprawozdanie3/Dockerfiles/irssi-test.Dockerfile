FROM irssi-build:latest

WORKDIR /irssi/Building

CMD ["ninja", "test"]