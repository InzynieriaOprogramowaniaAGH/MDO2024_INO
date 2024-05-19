FROM ubuntu

RUN apt-get update && \
    apt-get install git -y && \
    apt-get install make -y && \
    apt-get install gcc -y && \
    apt-get install libncurses5-dev libncursesw5-dev -y


RUN git clone https://github.com/alt-romes/programmer-calculator.git

WORKDIR /programmer-calculator

RUN make

