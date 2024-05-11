# syntax=docker/dockerfile:1

FROM deploy2_node:latest

ARG VERSION_UPDATE
ARG NPM_TOKEN
ARG NPM_PASSW

WORKDIR /node-js-tests-sample

RUN rm .npmrc
RUN npm config set //registry.npmjs.org/:_authToken=${NPM_TOKEN}
RUN npm install -g npm-cli-adduser

RUN npm-cli-adduser --username jakub_ficek --password ${NPM_PASSW} --email jakubficek138@gmail.com
RUN npm version ${VERSION_UPDATE} --no-git-tag-version

RUN npm publish