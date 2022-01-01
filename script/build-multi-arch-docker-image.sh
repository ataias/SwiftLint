#!/usr/bin/env bash

SWIFT_VERSION=${SWIFT_VERSION:-5.5.2}
SWIFTLINT_VERSION=${SWIFTLINT_VERSION:-$(git describe --abbrev=0)}
BASE_DEV_IMAGE=${BASE_DEV_IMAGE:-ataias/swift:${SWIFT_VERSION}-focal}
BASE_PROD_IMAGE=${BASE_PROD_IMAGE:-ataias/swift:${SWIFT_VERSION}-focal}
PROD_IMAGE_PREFIX=${PROD_IMAGE_PREFIX:-ataias}
PROD_IMAGE=$PROD_IMAGE_PREFIX:${SWIFTLINT_VERSION}
PROD_IMAGE_LATEST=$PROD_IMAGE_PREFIX:latest
HOST_ARM64=${HOST_ARM64:-unix:///var/run/docker.sock}
HOST_AMD64=${HOST_AMD64:-unix:///var/run/docker.sock}

cd $(git-root)

# TODO use docker build instead of buildx like this
docker --host $HOST_ARM64 \
    build \
    -t $PROD_IMAGE-arm64 \
    --build-arg BUILDER_IMAGE=$BASE_DEV_IMAGE \
    --build-arg RUNTIME_IMAGE=$BASE_PROD_IMAGE \
    --platform linux/arm64 \
    .

docker --host $HOST_AMD64 \
    build \
    -t $PROD_IMAGE-amd64 \
    --build-arg BUILDER_IMAGE=$BASE_DEV_IMAGE \
    --build-arg RUNTIME_IMAGE=$BASE_PROD_IMAGE \
    --platform linux/amd64 \
    .

docker --host $HOST_ARM64 push $PROD_IMAGE-arm64
docker --host $HOST_AMD64 push $PROD_IMAGE-amd64

docker manifest create -a $PROD_IMAGE \
    $PROD_IMAGE-arm64 \
    $PROD_IMAGE-amd64

docker manifest push $PROD_IMAGE

docker manifest create -a $PROD_IMAGE_LATEST \
    $PROD_IMAGE-arm64 \
    $PROD_IMAGE-amd64

docker manifest push $PROD_IMAGE_LATEST
