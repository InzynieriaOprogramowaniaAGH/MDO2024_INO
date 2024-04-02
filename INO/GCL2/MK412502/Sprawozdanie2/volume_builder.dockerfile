FROM node:latest

RUN mkdir input
RUN mkdir output

RUN --mount=type=bind,source=v_in,target=/input,rw
RUN --mount=type=bind,source=v_out,target=/output,rw

WORKDIR /input

RUN git clone https://github.com/devenes/node-js-dummy-test.git

WORKDIR /input/node-js-dummy-test

RUN npm install
RUN cp -r node_modules ../../output/n_node_modules