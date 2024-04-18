FROM node:latest

RUN mkdir in
RUN mkdir out

RUN --mount=type=bind,source=in,target=/in,rw
RUN --mount=type=bind,source=out,target=/out,rw
WORKDIR /in
RUN git clone https://github.com/devenes/node-js-dummy-test.git
WORKDIR /in/node-js-dummy-test
RUN npm install
RUN cp -r node_modules ../../out/new_node_modules