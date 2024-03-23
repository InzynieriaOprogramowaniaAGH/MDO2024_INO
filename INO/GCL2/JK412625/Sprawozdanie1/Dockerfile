FROM ubuntu:latest

RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

ENTRYPOINT ["tail", "-f", "/dev/null"]