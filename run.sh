#!/bin/bash

docker build -t cassandra:4 .
docker-compose up -d
