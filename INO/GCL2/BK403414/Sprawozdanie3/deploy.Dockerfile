FROM ubuntu
ADD ./artifacts /artifacts
RUN apt-get update
RUN apt-get install libncurses5-dev libncursesw5-dev -y
RUN tar -xvf artifacts/pcalc.tar
RUN cp artifacts/pcalc /