# syntax=docker/dockerfile:1

FROM bld_node:latest

ARG VERSION_UPDATE

WORKDIR /node-js-tests-sample

RUN npm install -g npm-cli-adduser

RUN npm-cli-adduser --registry http://0.0.0.0:4873 --username user --password pass --email email@example.com
RUN npm version ${VERSION_UPDATE} \
    npm publish --registry http://0.0.0.0:4873