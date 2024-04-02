FROM node

RUN mkdir /input
RUN mkdir /output

VOLUME /input
VOLUME /output

#RUN --mount=type=bind,source=/var/lib/docker/volumes/v_in,target=/input
#RUN --mount=type=bind,source=/var/lib/docker/volumes/v_out,target=/output

WORKDIR /input

RUN git clone https://github.com/aws-samples/node-js-tests-sample.git
WORKDIR /input/node-js-tests-sample
RUN npm install

RUN cp -r node_modules ../../output/new_node_modules