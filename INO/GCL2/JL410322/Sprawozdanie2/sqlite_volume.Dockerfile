FROM fedora

RUN mkdir -p /V_in /V_out

RUN dnf -y update && \
    dnf -y install git gcc tcl-devel

RUN git clone https://github.com/sqlite/sqlite.git
WORKDIR /sqlite
RUN ./configure
RUN make sqlite3





RUN --mount=type=volume,source=wol_in,target=/wol_out
RUN --mount=type=volume,source=wol_in,target=/wol_out

RUN git clone https://github.com/pencilblue/pencilblue.git
RUN mv pencilblue /wol_in

WORKDIR /wol_in/pencilblue
RUN npm install
RUN cp -r node_modules/ /wol_out