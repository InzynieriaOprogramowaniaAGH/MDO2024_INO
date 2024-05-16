FROM fedora:39 as base

RUN dnf -y update && \
    dnf -y install java-17-openjdk-devel zip python3 python3-pip

COPY ghidra.zip .
RUN unzip *.zip -d /ghidra
ENTRYPOINT sh -c "cd /ghidra/ghidra_* && ./ghidraRun"