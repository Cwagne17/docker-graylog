#!/bin/bash

# Author: cwagne17@students.towson.edu
# Description: Pulls Docker images for Graylog, Elasticsearch, and MongoDB and saves them to a tar file.
# Instruction: Run this script on a machine with Docker Desktop installed.

# Pull Docker Images

docker pull \
    graylog/graylog:5.0@sha256:f972e0a57141ddacb7431cd93510919acfc3d9b9bcf8c62972a3513738d70329 \
    docker.elastic.co/elasticsearch/elasticsearch-oss:7.10.2@sha256:2c257b68f361872e13bdd476cba152e232a314ec61b0eedfc1f71b628ba39432 \
    mongo:6.0.4@sha256:a4f2db6f54aeabba562cd07e5cb758b55d6192dcc6f36322a334ba0b0120aaf1

# Save Docker Images

docker save -o graylog.tar graylog/graylog:5.0 docker.elastic.co/elasticsearch/elasticsearch-oss:7.10.2 mongo:6.0.4
