#!/bin/bash

# Deleting images
if [ "$(docker images -q)" ]; then
  docker rmi -f $(docker images -q)
fi

#Deleting containers
if [ "$(docker ps -a -q)" ]; then
  docker stop -f $(docker ps -a -q)
  docker rm -f $(docker ps -a -q)
fi

# Directory for remporary logs, deleting them at the end and saving as artefacts
if [ ! -d "temp_logs" ]; then
  mkdir temp_logs
fi