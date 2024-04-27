# syntax=docker/dockerfile:1

FROM deploy2_node:latest

ARG VERSION_UPDATE
ARG NPM_TOKEN

WORKDIR /node-js-tests-sample

RUN rm .npmrc
#COPY .npmrc /node-js-tests-sample/.npmrc

RUN npm install -g npm-cli-adduser

RUN npm-cli-adduser --username jakub_ficek --password ${NPM_TOKEN} --email jakubficek138@gmail.com

RUN npm version ${VERSION_UPDATE} --no-git-tag-version

RUN npm publish