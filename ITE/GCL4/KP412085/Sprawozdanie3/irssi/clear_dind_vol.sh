#!/bin/bash

if [ "$(docker ps -a -q)" ]; then
  docker stop -f $(docker ps -a -q)
  docker rm -f $(docker ps -a -q)
fi

if [ "$(docker images -q)" ]; then
  docker rmi -f $(docker images -q)
fi