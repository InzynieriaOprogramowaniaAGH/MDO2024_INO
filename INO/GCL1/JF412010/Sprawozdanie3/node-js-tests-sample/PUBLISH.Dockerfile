# syntax=docker/dockerfile:1

FROM deploy2_node:latest

ARG NPM_TOKEN

WORKDIR /node-js-tests-sample

RUN rm .npmrc

RUN echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > .npmrc

RUN npm publish