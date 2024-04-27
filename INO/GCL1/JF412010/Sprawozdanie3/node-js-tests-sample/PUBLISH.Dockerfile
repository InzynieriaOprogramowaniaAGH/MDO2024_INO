# syntax=docker/dockerfile:1

FROM deploy2_node:latest

ARG NPM_TOKEN
ARG VERSION_UPDATE

WORKDIR /node-js-tests-sample

RUN rm .npmrc
#RUN echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > .npmrc

RUN npm version ${VERSION_UPDATE} --no-git-tag-version
RUN npm login
RUN npm publish