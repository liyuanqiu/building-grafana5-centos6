#!/bin/bash

set -ex

git clone $GIT_REPO /tmp/grafana

cd /tmp/grafana

git checkout $GIT_BRANCH

mkdir -p $GOPATH/src/github.com/grafana

ln -s /tmp/grafana $GOPATH/src/github.com/grafana/grafana

cd $GOPATH/src/github.com/grafana/grafana

http_proxy=$HTTP_PROXY https_proxy=$HTTPS_PROXY go run build.go setup

go run build.go build

http_proxy=$HTTP_PROXY https_proxy=$HTTPS_PROXY yarn install --pure-lockfile

go run build.go build package

cp -r dist /dist/dist-`date +%s`
