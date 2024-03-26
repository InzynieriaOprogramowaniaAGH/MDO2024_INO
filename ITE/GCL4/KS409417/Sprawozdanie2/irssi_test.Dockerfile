FROM irssi_builder

WORKDIR /Build
CMD ["ninja", "test"]