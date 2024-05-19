FROM fedora:39 as base

RUN dnf -y update && \
    dnf -y install java-17-openjdk-devel gcc g++ git zip wget python3 python3-pip glibc-devel

ARG GRADLE_VERSION=8.7
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip   
RUN mkdir -p /opt/gradle
RUN unzip -d /opt/gradle gradle-${GRADLE_VERSION}-bin.zip
RUN rm gradle-${GRADLE_VERSION}-bin.zip
RUN git clone https://github.com/curaposterior/ghidra.git
WORKDIR /ghidra
RUN /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle -I gradle/support/fetchDependencies.gradle init

FROM base as build
WORKDIR /ghidra
RUN /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle buildGhidra

FROM build as test

WORKDIR /ghidra
RUN Xvfb :99 -nolisten tcp &
RUN export DISPLAY=:99
RUN /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle unitTestReport

FROM build as deploy

WORKDIR /ghidra/build/dist
RUN unzip *.zip
RUN rm *.zip
RUN cd /ghidra/build/dist/ghidra_* && set -e; ./ghidraRun