#!/bin/bash

set -e

wget "https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz" -P ./vendors
wget "https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.6.tar.gz" -P ./vendors


docker build \
  --build-arg HTTP_PROXY="http://192.168.50.159:1087" \
  --build-arg HTTPS_PROXY="http://192.168.50.159:1087" \
  -t building-grafana .