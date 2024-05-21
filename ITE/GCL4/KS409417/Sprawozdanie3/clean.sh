#!/bin/bash

if [ "$(docker ps -a -q)" ]; then
  docker container stop -f $(docker ps -a -q)
  docker container rm -f $(docker ps -a -q)
fi