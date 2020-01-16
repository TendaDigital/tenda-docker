#!/bin/sh

set -e

docker build --rm -t "tendadigital/cicd" .
docker push tendadigital/cicd:latest