FROM node:latest

RUN mkdir input
RUN mkdir output

RUN --mount=type=bind,source=v_in,target=/input,rw
RUN --mount=type=bind,source=v_out,target=/output,rw
WORKDIR /input
RUN git clone https://github.com/aws-samples/node-js-tests-sample.git
WORKDIR /input/node-js-tests-sample
RUN npm install
RUN cp -r node_modules ../../output/new_node_modules