FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y git
WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
CMD ["/bin/bash"]
