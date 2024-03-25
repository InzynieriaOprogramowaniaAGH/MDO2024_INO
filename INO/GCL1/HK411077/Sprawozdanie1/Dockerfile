FROM ubuntu:latest

RUN apt-get update && apt-get install -y git ssh

WORKDIR /projekt

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

ENTRYPOINT ["/bin/bash"]
