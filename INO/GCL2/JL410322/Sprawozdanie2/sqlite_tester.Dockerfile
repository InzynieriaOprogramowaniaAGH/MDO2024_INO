FROM sqlite_builder

WORKDIR /sqlite
RUN make devtest
