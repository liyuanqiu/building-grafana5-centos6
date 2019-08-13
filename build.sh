#!/bin/bash

set -ex

GO_PKG="go1.12.7.linux-amd64.tar.gz"
RUBY_PKG="ruby-2.4.6.tar.gz"
RUBY_DIR="ruby-2.4.6"
NODE_PKG="node-v8.16.0-linux-x64.tar.gz"
NODE_DIR="node-v8.16.0-linux-x64"

GO_URL="https://dl.google.com/go/$GO_PKG"
RUBY_URL="https://cache.ruby-lang.org/pub/ruby/2.4/$RUBY_PKG"
NODE_URL="https://nodejs.org/dist/latest-v8.x/$NODE_PKG"

_HTTP_PROXY=$HTTP_PROXY
[ -z "$HTTP_PROXY" ] && _HTTP_PROXY=$http_proxy

_HTTPS_PROXY=$HTTPS_PROXY
[ -z "$HTTPS_PROXY" ] && _HTTPS_PROXY=$https_proxy

mkdir -p vendors
[ ! -f ./vendors/$GO_PKG ] && \
  wget "$GO_URL" -P ./vendors
[ ! -f ./vendors/$RUBY_PKG ] && \
  wget "$RUBY_URL" -P ./vendors
[ ! -f ./vendors/$NODE_PKG ] && \
  wget "$NODE_URL" -P ./vendors


docker build \
  --build-arg GO_PKG="$GO_PKG" \
  --build-arg RUBY_PKG="$RUBY_PKG" \
  --build-arg RUBY_DIR="$RUBY_DIR" \
  --build-arg NODE_PKG="$NODE_PKG" \
  --build-arg NODE_DIR="$NODE_DIR" \
  ${_HTTP_PROXY:+ --build-arg HTTP_PROXY="$_HTTP_PROXY"} \
  ${_HTTPS_PROXY:+ --build-arg HTTPS_PROXY="$_HTTPS_PROXY"} \
  -t building-grafana .