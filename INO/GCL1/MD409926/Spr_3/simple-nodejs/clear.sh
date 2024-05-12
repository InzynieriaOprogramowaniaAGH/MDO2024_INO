#!/bin/bash

if [ "$(docker images -q)" ]; then
  docker rmi -f $(docker images -q)
fi

if [ "$(docker ps -a -q)" ]; then
  docker rm -f $(docker ps -a -q)
fi

if [ ! -d "logs" ]; then
  mkdir logs
fi
