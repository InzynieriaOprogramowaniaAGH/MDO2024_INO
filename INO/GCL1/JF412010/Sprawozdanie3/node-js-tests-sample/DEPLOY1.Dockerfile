# syntax=docker/dockerfile:1

FROM bld_node:latest

ARG VERSION_UPDATE
ARG HOST_IP

WORKDIR /node-js-tests-sample

RUN npm install -g npm-cli-adduser

RUN npm-cli-adduser --registry http://${HOST_IP}:4873 --username user --password pass --email email@example.com
RUN npm version ${VERSION_UPDATE} --no-git-tag-version
RUN npm publish --registry http://${HOST_IP}:4873