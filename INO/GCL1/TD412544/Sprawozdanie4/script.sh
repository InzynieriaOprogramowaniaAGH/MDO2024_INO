#!/bin/bash

docker pull ullei/irssi:1.0.0
docker run -it -d --name irssi ullei/irssi:1.0.0
