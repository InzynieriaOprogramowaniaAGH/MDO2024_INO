FROM node

RUN mkdir /input && mkdir /output

RUN --mount=type=bind,source=input,target=/input,rw
RUN --mount=type=bind,source=output,target=/output,rw

WORKDIR /input
RUN git clone https://github.com/devenes/node-js-dummy-test.git

WORKDIR /input/node-js-dummy-test
RUN npm install
CMD ["cp", "-r", "node_modules", "../../output/dockerfilebuild"]