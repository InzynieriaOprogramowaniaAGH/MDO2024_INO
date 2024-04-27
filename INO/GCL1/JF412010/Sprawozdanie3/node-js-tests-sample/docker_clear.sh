#!/bin/bash

# Deleting .npmrc file
if [ -f ".npmrc" ]; then
  rm .npmrc
fi

# Deleting images
if [ "$(docker images -q)" ]; then
  docker rmi -f $(docker images -q)
fi

# Deleting containers
if [ "$(docker ps -a -q)" ]; then
  docker stop -f $(docker ps -a -q)
  docker rm -f $(docker ps -a -q)
fi

# Directory for temporary logs, deleting them at the end and saving as artifacts
if [ ! -d "temp_logs" ]; then
  mkdir temp_logs
fi
