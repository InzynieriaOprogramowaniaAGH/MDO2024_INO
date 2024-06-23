FROM ubuntu

RUN apt-get update && apt-get install -y gnupg wget && \
    wget -qO - http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x871920D1991BC93C | apt-key add -

RUN apt-get update && \
    apt-get install -y \
    git \
    libncurses5-dev libncursesw5-dev \
    gcc \
    make && \
    git clone https://github.com/alt-romes/programmer-calculator && \ 
    cd programmer-calculator && \
    make install

