FROM ubuntu:latest

WORKDIR /app


RUN apt-get update && apt-get install -y git || \
    zypper --non-interactive install git || \
    dnf install -y git

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

ENTRYPOINT ["/bin/bash"]
