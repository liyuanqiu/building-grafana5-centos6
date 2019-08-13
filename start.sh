#!/bin/bash

set -ex

if [ -z "$GIT_REPO" ]
then
  echo "GIT_REPO missing"
  exit 1
fi

if [ -z "$GIT_BRANCH" ]
then
  echo "GIT_BRANCH missing"
  exit 1
fi

_HTTP_PROXY=$HTTP_PROXY
[ -z "$HTTP_PROXY" ] && _HTTP_PROXY=$http_proxy

_HTTPS_PROXY=$HTTPS_PROXY
[ -z "$HTTPS_PROXY" ] && _HTTPS_PROXY=$https_proxy

_NO_PROXY=$NO_PROXY
[ -z "$NO_PROXY" ] && _NO_PROXY=$no_proxy

docker run -it \
  -e GIT_REPO=$GIT_REPO \
  -e GIT_BRANCH=$GIT_BRANCH \
  ${_HTTP_PROXY:+ -e HTTP_PROXY="$_HTTP_PROXY"} \
  ${_HTTPS_PROXY:+ -e HTTPS_PROXY="$_HTTPS_PROXY"} \
  ${_NO_PROXY:+ -e NO_PROXY="$_NO_PROXY"} \
  -v `pwd`/dist:/dist \
  building-grafana:latest