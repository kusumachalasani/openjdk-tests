#!/bin/sh

JVM_VERSION=$2
dockerImageTag=$3

mvn clean package -Dno-native && docker build -f Dockerfile-quarkus-jvm -t rest-crud-quarkus-jvm . --pull --build-arg --build-arg SDK=$JVM_VERSION --build-arg IMAGE_VERSION=$dockerImageTag .
