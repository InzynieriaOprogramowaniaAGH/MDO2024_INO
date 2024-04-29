FROM irssi-test

COPY --from=irssi-test /irssi/Build/irssi /Deploy/irssi
COPY --from=irssi-test /irssi/Build/src /Deploy/src

