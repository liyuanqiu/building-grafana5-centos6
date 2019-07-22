#!/bin/bash

set -ex

mkdir -p $GOPATH/src/github.com/grafana

ln -s /src $GOPATH/src/github.com/grafana/grafana

cd $GOPATH/src/github.com/grafana/grafana

http_proxy=$HTTP_PROXY https_proxy=$HTTPS_PROXY go run build.go setup

go run build.go build

http_proxy=$HTTP_PROXY https_proxy=$HTTPS_PROXY yarn install --pure-lockfile

go run build.go build package

cp -r dist /dist/dist-`date +%s`
