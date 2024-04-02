FROM irssi-builder

WORKDIR /Build
CMD ["ninja", "test"]