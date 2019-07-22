#!/bin/bash

set -e

if [ -d ./src ]
then
  rm -rf ./src
fi

git clone ./grafana-5.2.3-displayx ./src

docker run \
  -e HTTP_PROXY="http://192.168.50.159:1087" \
  -e HTTPS_PROXY="http://192.168.50.159:1087" \
  -v `pwd`/dist:/dist \
  -v `pwd`/src:/src \
  building-grafana:latest