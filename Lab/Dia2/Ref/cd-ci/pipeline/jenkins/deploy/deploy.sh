#!/bin/bash

# Generamos
echo app > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $PASS >> /tmp/.auth


# Transifere el archivo
scp   -i /opt/aws_linuxfacilito.pem /tmp/.auth  centos@linuxfacilito.online:/tmp/.auth
scp -i /opt/aws_linuxfacilito.pem ./jenkins/deploy/publish centos@linuxfacilito.online:/tmp/publish
ssh -i /opt/aws_linuxfacilito.pem  centos@linuxfacilito.online /tmp/publish
