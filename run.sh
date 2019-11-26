#!/bin/sh

TARGET="site"

[ -d $TARGET ] || mkdir $TARGET
docker run --rm -iv $(pwd)/$TARGET:/web pluxml:alpine
# docker run --rm -tiv $(pwd)/$TARGET:/web pluxml:alpine /bin/sh
