FROM fedora

RUN dnf -y update && \
    dnf -y install git

WORKDIR /repo

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

ENTRYPOINT ["/bin/bash"]
