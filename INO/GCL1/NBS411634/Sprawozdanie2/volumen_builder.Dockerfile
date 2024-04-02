FROM node:latest

RUN mkdir input
RUN mkdir output

RUN --mount=type=bind,source=input_volume,target=/input,rw
RUN --mount=type=bind,source=output_volume,target=/output,rw

WORKDIR /input

RUN git clone https://github.com/codeclown/tesseract.js-node.git

WORKDIR /input/tesseract.js-node

RUN npm install
RUN cp -r node_modules ../../output/new_node_modules