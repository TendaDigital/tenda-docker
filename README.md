# Tenda docker images

This repo holds the Docker files using linux alpine for our test and production machines. Linux Alpine is well known for it's low size, security and reliability, knowing that we decided to build some images based on it to speed-up our CI/CD pipelines.

## docker-gcloud

This image pulls from docker:latest, already an Alpine:3.6 based image, so we installed on top of that the Google Cloud SDK, just using it for building and deploy purpose.

## node-alpine

This image pulls directly from Alpine:3.6, and installs `node 8.6.0` and `Yarn`, leaving also the following packages available so you can build node packages that use node-gyp.

  - make
  - g++
  - gcc
  - python2
  - libc6-compat

### Known issues
  - Alpine linux based images use musl libc instead of the standard glibc and thus are not compatible with compiled binaries. node-pre-gyp currently does not test the pre-compiled binaries to be ABI-compatible and thus you may see segfaults. Ass seen [here](https://github.com/kelektiv/node.bcrypt.js/issues/528).
  - bcrypt is one of this packages
