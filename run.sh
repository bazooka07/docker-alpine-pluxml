#!/bin/sh

IMAGE="pluxml:alpine"
TARGET="site"

if [ -z $(command -v docker) ]; then
	echo << EOT
Docker is required
Look at :
https://docs.docker.com/install/linux/docker-ce/ubuntu/

EOT
	exit
fi

if [ -z  $(docker image ls $IMAGE --format '{{.ID}}') ]; then
	echo "\e[91m $IMAGE is building. Please wait for it \e[m"
       	docker build . -t $IMAGE
	echo "\e[32mDone\e[m\n"
fi

OTHER="docker run --rm -tiv $(pwd)/$TARGET:/web $IMAGE /bin/sh"
echo "\nExecute the following command for interaction with the image :\n\e[36m$OTHER\e[m\n"

echo "\e[33m --------- Image Docker : $IMAGE ---------\e[m"
docker image ls $IMAGE --format 'table{{.CreatedSince}}\t{{.Size}}\t{{.ID}}'


[ -d $TARGET ] || mkdir $TARGET
docker run --rm -iv $(pwd)/$TARGET:/web $IMAGE

