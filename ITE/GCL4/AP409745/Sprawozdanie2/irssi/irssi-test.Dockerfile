FROM irssi-build

WORKDIR /build
CMD ["ninja", "test"]