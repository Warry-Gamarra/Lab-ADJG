#!/bin/bash

echo "****************"
echo "* Building jar!*"
echo "****************"

PROJ=/home/ricardo/jenkins/jenkins_home/workspace/pipeline-docker-maven
docker run --rm -v /root/.m2:/root/.m2 -v $PROJ/java-app:/app -w /app maven:3-alpine "$@"
