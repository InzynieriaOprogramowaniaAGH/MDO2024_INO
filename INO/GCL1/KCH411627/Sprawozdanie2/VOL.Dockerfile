FROM ubuntu

RUN mkdir input && \
    mkdir output

RUN --mount=type=bind,source=vol_input,target=/input,rw && \
    --mount=type=bind,source=vol_output,target=/output,rw

RUN apt update && \
    apt upgrade -y && \
    apt install -y git && \
    apt install -y maven

WORKDIR /input
RUN git clone https://github.com/davidmoten/maven-demo.git
WORKDIR /maven-demo
RUN mvn clean install
RUN cp -r target ../../output
