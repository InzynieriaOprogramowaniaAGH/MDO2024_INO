FROM node:latest

RUN mkdir input
RUN mkdir output

RUN --mount=type=bind,source=v_in,target=/input,rw
RUN --mount=type=bind,source=v_out,target=/output,rw

WORKDIR /input

RUN git clone https://github.com/devenes/node-js-dummy-test.git
WORKDIR /input/node-js-dummy-test
RUN npm install -g npm@10.5.1
RUN cp -r node_modules ../../output/new_node_modules
