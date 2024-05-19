FROM ubuntu

RUN --mount=type=bind,source=wejsciowy,target=/input 
RUN --mount=type=bind,source=wyjsciowy,target=/output

RUN apt update && apt-get install -y make gcc libncurses5-dev libncursesw5-dev

WORKDIR /input/programmer-calculator

RUN make

RUN cp -r bin ../../../output


