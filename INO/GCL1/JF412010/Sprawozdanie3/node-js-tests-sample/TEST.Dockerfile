# syntax=docker/dockerfile:1

FROM bld_node:latest

WORKDIR /node-js-tests-sample
RUN npm test