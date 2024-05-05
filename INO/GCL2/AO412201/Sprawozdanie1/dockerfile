FROM ubuntu:latest

RUN apt-get update && apt-get install -y git
WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO /app

COPY . /app
CMD ["bash"]
