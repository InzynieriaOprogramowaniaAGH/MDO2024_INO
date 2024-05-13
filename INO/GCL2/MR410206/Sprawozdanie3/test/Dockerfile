FROM ubuntu

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y default-jdk && \
    apt-get install -y maven
    
RUN git clone https://github.com/sanity/LastCalc.git

WORKDIR LastCalc
RUN mvn test