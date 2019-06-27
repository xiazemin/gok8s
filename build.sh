#!/bin/sh
echo Building xiazemin/docker-multi-stage-demo:build

docker build -t xiazemin/docker-multi-stage-demo:build . -f Dockerfile.build

docker create --name extract xiazemin/docker-multi-stage-demo:build
docker cp extract:/go/src/app/app-server ./app-server
docker rm -f extract

echo Building xiazemin/docker-multi-stage-demo:old

docker build --no-cache -t xiazemin/docker-multi-stage-demo:old . -f Dockerfile.old
rm ./app-server
