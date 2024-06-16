FROM fedora

RUN dnf -y update && \
    dnf -y install git gcc tcl-devel

RUN git clone https://github.com/sqlite/sqlite.git
WORKDIR /sqlite
RUN ./configure
RUN make sqlite3
