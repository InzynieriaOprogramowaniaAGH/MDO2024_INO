FROM fedora:latest as base

RUN dnf -y update && \
    dnf -y install java-17-openjdk-devel gcc g++ git zip wget
RUN wget https://services.gradle.org/distributions/gradle-8.7-bin.zip
RUN mkdir -p /opt/gradle
RUN unzip -d /opt/gradle gradle-8.7-bin.zip
RUN rm gradle-8.7-bin.zip

RUN git clone https://github.com/NationalSecurityAgency/ghidra.git

FROM base as build
WORKDIR /ghidra
RUN /opt/gradle/gradle-8.7/bin/gradle -I gradle/support/fetchDependencies.gradle init
RUN /opt/gradle/gradle-8.7/bin/gradle buildGhidra
RUN ls build/dist

# https://github.com/NationalSecurityAgency/ghidra/blob/master/DevGuide.md

FROM build as test

WORKDIR /ghidra

RUN Xvfb :99 -nolisten tcp &
RUN export DISPLAY=:99
RUN /opt/gradle/gradle-8.7/bin/gradle unitTestReport