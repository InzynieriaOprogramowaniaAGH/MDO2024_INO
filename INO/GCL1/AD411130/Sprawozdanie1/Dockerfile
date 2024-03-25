FROM ubuntu:latest
WORKDIR /repo
RUN apt-get update && apt-get install -y git ssh
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
CMD ["/bin/bash"]