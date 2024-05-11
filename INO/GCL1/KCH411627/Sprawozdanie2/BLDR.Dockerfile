FROM ubuntu

RUN apt update && \
    apt upgrade -y && \
    apt install -y git && \
    apt install -y maven

RUN git clone https://github.com/davidmoten/maven-demo.git
WORKDIR /maven-demo
RUN mvn clean install

