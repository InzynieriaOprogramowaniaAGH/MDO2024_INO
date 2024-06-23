FROM ubuntu

RUN apt-get update && \
    apt-get install -y \
    git \
    libncurses5-dev libncursesw5-dev \
    gcc \
    make && \
    git clone https://github.com/alt-romes/programmer-calculator && \ 
    cd programmer-calculator && \
    make install

