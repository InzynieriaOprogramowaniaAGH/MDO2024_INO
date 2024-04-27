# syntax=docker/dockerfile:1

FROM deploy2_node:latest

ARG VERSION_UPDATE
ARG NPM_TOKEN

RUN rm .npmrc

WORKDIR /node-js-tests-sample

RUN rm package_lock.json
RUN npm install

#COPY .npmrc /node-js-tests-sample/.npmrc

RUN npm version ${VERSION_UPDATE} --no-git-tag-version
RUN npm set //registry.npmjs.org/:_authToken=${NPM_TOKEN}
RUN npm publish