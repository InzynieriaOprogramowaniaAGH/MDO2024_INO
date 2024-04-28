# syntax=docker/dockerfile:1

FROM deploy2_node:latest

ARG VERSION_UPDATE
ARG NPM_TOKEN

WORKDIR /node-js-tests-sample

RUN rm .npmrc
#COPY .npmrc /node-js-tests-sample/.npmrc

#RUN npm config set //registry.npmjs.org/:_authToken=${NPM_TOKEN}

RUN npm config list

RUN npm version ${VERSION_UPDATE} --no-git-tag-version

RUN npm publish