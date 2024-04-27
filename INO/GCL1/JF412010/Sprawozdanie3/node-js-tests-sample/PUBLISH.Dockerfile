# syntax=docker/dockerfile:1

FROM deploy2_node:latest

ARG VERSION_UPDATE
ARG NPM_TOKEN

WORKDIR /node-js-tests-sample

RUN rm .npmrc
RUN rm package-lock.json
RUN ls -a
#COPY .npmrc /node-js-tests-sample/.npmrc

RUN npm install
RUN npm version ${VERSION_UPDATE} --no-git-tag-version
RUN npm set //registry.npmjs.org/:_authToken=${NPM_TOKEN}
RUN npm publish