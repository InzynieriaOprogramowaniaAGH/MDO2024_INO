FROM ubuntu

RUN apt-get update && apt-get install -y git ssh
ARG SSH_PRIVATE_KEY

RUN git --version > git_version.txt

RUN mkdir /root/.ssh/ && \
    echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_ed25519 && \
    chmod 600 /root/.ssh/id_ed25519 && \
    touch /root/.ssh/known_hosts && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts && \
    git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git