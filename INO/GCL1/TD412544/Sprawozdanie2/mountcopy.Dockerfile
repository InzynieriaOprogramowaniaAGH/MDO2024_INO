FROM node:latest
RUN mkdir indir
RUN mkdir outdir

RUN --mount=type=bind,source=IN,target=/indir,rw
RUN --mount=type=bind,source=OUT,target=/outdir,rw

WORKDIR /indir
RUN git clone https://github.com/devenes/node-js-dummy-test.git
WORKDIR /indir/node-js-dummy-test
RUN npm install
RUN cp -r ../node-js-dummy-test /outdir
