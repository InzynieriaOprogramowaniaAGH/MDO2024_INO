FROM maven:latest

RUN git clone https://github.com/spring-projects/spring-petclinic.git

WORKDIR /spring-petclinic

RUN mvn package