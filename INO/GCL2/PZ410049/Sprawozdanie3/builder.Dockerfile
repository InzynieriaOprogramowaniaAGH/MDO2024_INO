FROM maven:3.8.4-openjdk-17-slim
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/benek2002/jenkins-java.git
WORKDIR /jenkins-java
RUN mvn clean install -DskipT